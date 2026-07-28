document.addEventListener('DOMContentLoaded', async () => {
  console.log('[GuardianX Admin Panel] Initialized.');

  const sampleUsers = [
    { name: 'Sarah Jenkins', email: 'parent@guardianx.ai', plan: 'Family Plan ($89.99/yr)', devices: 2, status: 'Active', date: '2026-01-15' },
    { name: 'Michael Vance', email: 'm.vance@example.com', plan: 'Yearly Pro ($59.99/yr)', devices: 1, status: 'Active', date: '2026-02-10' },
    { name: 'Elena Rostova', email: 'elena.r@example.org', plan: 'Monthly ($9.99/mo)', devices: 3, status: 'Active', date: '2026-03-22' },
    { name: 'David Miller', email: 'dmiller@example.net', plan: 'Family Plan ($89.99/yr)', devices: 4, status: 'Active', date: '2026-04-05' }
  ];

  const tbody = document.getElementById('users-tbody');
  if (tbody) {
    tbody.innerHTML = sampleUsers.map(u => `
      <tr>
        <td><strong>${u.name}</strong></td>
        <td>${u.email}</td>
        <td>${u.plan}</td>
        <td>${u.devices} Devices</td>
        <td><span class="status-badge status-active">${u.status}</span></td>
        <td>${u.date}</td>
      </tr>
    `).join('');
  }
});
