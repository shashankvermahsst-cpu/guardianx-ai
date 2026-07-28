package ai.guardianx.child

import android.app.admin.DeviceAdminReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast

class GuardianXAdminReceiver : DeviceAdminReceiver() {
    override fun onEnabled(context: Context, intent: Intent) {
        super.onEnabled(context, intent)
        Toast.makeText(context, "GuardianX Device Admin Protection Activated", Toast.LENGTH_SHORT).show()
    }

    override fun onDisableRequested(context: Context, intent: Intent): CharSequence {
        return "GuardianX Anti-Uninstall Guard: Disabling Device Admin requires Parent Passcode."
    }

    override fun onDisabled(context: Context, intent: Intent) {
        super.onDisabled(context, intent)
        Toast.makeText(context, "GuardianX Device Admin Protection Deactivated", Toast.LENGTH_SHORT).show()
    }
}
