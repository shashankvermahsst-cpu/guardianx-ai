function switchDemoView(viewName) {
  const box = document.getElementById('demo-content-area');
  if (!box) return;

  if (viewName === 'location') {
    box.innerHTML = `
      <span style="font-size: 48px;">📍</span>
      <h3 style="margin-top: 12px; color: #fff;">Live GPS Tracking Active</h3>
      <p style="color: #a4b0be; font-size: 14px;">Location: 742 Evergreen Terrace, San Francisco, CA</p>
      <span style="color: #2ed573; font-size: 12px; margin-top: 6px; display: inline-block;">✓ Inside School SafeZone Radius (200m) • Speed: 0 mph</span>
    `;
  } else if (viewName === 'screen') {
    box.innerHTML = `
      <span style="font-size: 48px;">📺</span>
      <h3 style="margin-top: 12px; color: #fff;">Live Screen Mirror Stream</h3>
      <p style="color: #a4b0be; font-size: 14px;">Child is active on: <strong>YouTube (Science Video)</strong></p>
      <span style="color: #00cec9; font-size: 12px; margin-top: 6px; display: inline-block;">● 1080p HD • Latency: 28ms • Encrypted AES-256</span>
    `;
  } else if (viewName === 'camera') {
    box.innerHTML = `
      <span style="font-size: 48px;">📷</span>
      <h3 style="margin-top: 12px; color: #fff;">Remote Camera Preview</h3>
      <p style="color: #a4b0be; font-size: 14px;">Camera Selected: <strong>Rear HD Lens</strong></p>
      <button style="margin-top: 10px; background: #6c5ce7; color: #fff; border: none; padding: 8px 16px; border-radius: 20px; cursor: pointer;" onclick="alert('Snapshot Captured Silently! Saved to Cloud Vault.')">📸 Capture Silent Snapshot</button>
    `;
  } else if (viewName === 'ai') {
    box.innerHTML = `
      <span style="font-size: 48px;">🤖</span>
      <h3 style="margin-top: 12px; color: #fff;">GuardianX AI Assistant</h3>
      <p style="color: #a4b0be; font-size: 14px;">Parent Query: <em>"How much YouTube did Alex watch today?"</em></p>
      <div style="background: rgba(108, 92, 231, 0.2); padding: 12px 20px; border-radius: 12px; margin-top: 10px; color: #00cec9; font-size: 13px;">
        "Alex watched YouTube for 52 minutes today. Addiction Risk Score is Low (22/100)."
      </div>
    `;
  }
}

document.getElementById('btn-sync')?.addEventListener('click', () => {
  alert('Telemetry refreshed from GuardianX Backend Socket Server!');
});
