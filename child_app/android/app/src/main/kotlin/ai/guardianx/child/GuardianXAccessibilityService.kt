package ai.guardianx.child

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.content.Intent
import android.provider.Settings
import android.widget.Toast

class GuardianXAccessibilityService : AccessibilityService() {
    private val blockedPackages = setOf("com.zhiliaoapp.musically", "com.roblox.client")

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null || event.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return
        val packageName = event.packageName?.toString() ?: return

        // 1. Intercept Blocked Apps (TikTok, Games)
        if (blockedPackages.contains(packageName)) {
            val intent = Intent(Intent.ACTION_MAIN).apply {
                addCategory(Intent.CATEGORY_HOME)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            startActivity(intent)
            Toast.makeText(applicationContext, "GuardianX Shield: App blocked by parent rule.", Toast.LENGTH_SHORT).show()
        }

        // 2. Auto-Reopen Location Settings if Child attempts to disable GPS
        if (packageName.contains("settings") && event.className?.toString()?.contains("Location") == true) {
            val locationIntent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            startActivity(locationIntent)
            Toast.makeText(applicationContext, "GuardianX Shield: Location Service is required for Safety Monitoring.", Toast.LENGTH_LONG).show()
        }
    }

    override fun onInterrupt() {}
}
