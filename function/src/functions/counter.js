const { app } = require('@azure/functions');
const { CosmosClient } = require('@azure/cosmos');
const { DefaultAzureCredential } = require('@azure/identity');

// DefaultAzureCredential picks up the Function App's system-assigned managed
// identity automatically when running in Azure — no key or connection
// string involved. See the azurerm_cosmosdb_sql_role_assignment in
// terraform/cosmos.tf for the permission that makes this work.
const client = new CosmosClient({
  endpoint: process.env.COSMOS_ENDPOINT,
  aadCredentials: new DefaultAzureCredential(),
});

const container = client
  .database(process.env.COSMOS_DATABASE)
  .container(process.env.COSMOS_CONTAINER);

// Partition key path is /id, so the single counter document is both its own
// id and its own partition key.
const COUNTER_ID = 'visitor-count';

app.http('counter', {
  methods: ['GET'],
  authLevel: 'anonymous',
  handler: async (request, context) => {
    try {
      let existing;
      try {
        const response = await container.item(COUNTER_ID, COUNTER_ID).read();
        existing = response.resource;
      } catch (error) {
        if (error.code !== 404) throw error;
        existing = undefined; // first visitor ever
      }

      const count = (existing?.count ?? 0) + 1;
      await container.items.upsert({ id: COUNTER_ID, count });

      return { jsonBody: { count } };
    } catch (error) {
      context.error('Failed to update counter', error);
      return { status: 500, jsonBody: { error: 'Failed to update counter' } };
    }
  },
});
