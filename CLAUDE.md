# Cloud Resume Challenge — Azure

## What this is
A résumé website with a visitor counter, built to learn cloud/DevOps and to
show on my résumé. Stack: Azure + Terraform + GitHub Actions.

## How I want you to work with me
I'm transitioning into cloud/DevOps and still learning. Your job is to write
boilerplate so I don't waste time typing it — but I must UNDERSTAND everything.
- Explain each file and each resource block; don't just dump code.
- Before any `terraform apply` or destructive command, show me the plan and
  wait for my confirmation. Never run apply on your own.
- When you generate Terraform, briefly note what each resource is, what it
  depends on, and whether a change would create/update/replace/destroy it.
- Keep changes small and reviewable — one phase at a time.

## Architecture (target)
- Resource Group — container for everything (delete it = tear it all down).
- Static Web App (Free tier) — hosts the front end, gives the shareable link.
- Azure Function — serverless counter API (pay per execution).
- Cosmos DB (Free tier) — stores the count. NOTE: only one free-tier Cosmos
  account per subscription; opt in at creation.
- Storage Account — remote backend for Terraform state (not part of the app).

## Cost rules
Free tiers only. Avoid always-on/hourly resources (VMs, AKS, App Service
Basic+, Application Gateway, NAT Gateway, provisioned SQL).

## Build phases
0. Prereqs (done)
1. Bare static site (index.html) deployed MANUALLY to a Static Web App first.
2. Terraform-ify infra + remote state backend.
3. Add Function API + Cosmos DB counter.
4. GitHub Actions CI/CD: plan on PR, apply on merge, OIDC auth.
5. Polish: README with architecture diagram.

## Current status
Phase 1. Only build the static site now. Do NOT write Terraform yet.