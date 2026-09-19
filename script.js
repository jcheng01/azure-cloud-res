(function () {
  const COUNTER_API_URL = 'https://func-cloud-resume-910aba.azurewebsites.net/api/counter';

  const el = document.getElementById('visitor-count');
  if (!el) return;

  fetch(COUNTER_API_URL)
    .then((response) => {
      if (!response.ok) throw new Error(`Request failed: ${response.status}`);
      return response.json();
    })
    .then((data) => {
      el.textContent = data.count;
    })
    .catch((error) => {
      console.error('Failed to load visitor count', error);
      el.textContent = '—';
    });
})();
