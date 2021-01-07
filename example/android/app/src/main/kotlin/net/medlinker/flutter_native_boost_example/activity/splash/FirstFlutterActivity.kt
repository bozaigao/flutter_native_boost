package net.medlinker.flutter_native_boost_example.activity.splash

import android.content.Context
import android.os.Build
import android.os.Bundle
import net.medlinker.flutter_native_boost.Container
import net.medlinker.flutter_native_boost.ContainerActivity
import net.medlinker.flutter_native_boost.channels.postNotification
import net.medlinker.flutter_native_boost.channels.registerNotification
import net.medlinker.flutter_native_boost.channels.unregisterNotification
import net.medlinker.flutter_native_boost_example.widget.NotificationDialog

class FirstFlutterActivity : ContainerActivity() {

    companion object {
        fun build(context: Context) = builder<FirstFlutterActivity>("home", null, false).build(context)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Container.registerNotification("GlobalNotification") {
            showNotification()
        }
    }

    private fun showNotification() {
        NotificationDialog(this, "Notification from Flutter").apply {
            setOnDismissListener {
                Container.postNotification("NotificationFromNative", "Hi, Android ${Build.VERSION.RELEASE}")
            }
        }.show()
    }

    override fun onDestroy() {
        super.onDestroy()
        Container.unregisterNotification("GlobalNotification")
    }
}