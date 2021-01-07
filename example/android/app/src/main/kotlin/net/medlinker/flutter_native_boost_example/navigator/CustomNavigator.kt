package net.medlinker.flutter_native_boost_example.navigator

import android.app.Activity
import android.content.Intent
import android.graphics.Color
import android.net.Uri
import net.medlinker.flutter_native_boost.Container
import net.medlinker.flutter_native_boost.ContainerActivity
import net.medlinker.flutter_native_boost.ContainerNavigator
import net.medlinker.flutter_native_boost.Options
import net.medlinker.flutter_native_boost_example.activity.SingleTaskFlutterActivity
import net.medlinker.flutter_native_boost_example.basic.FlutterToNativeActivity
import net.medlinker.flutter_native_boost_example.basic.Native2FlutterActivity
import net.medlinker.flutter_native_boost_example.basic.TabContainerActivity
import net.medlinker.flutter_native_boost_example.basic.TransparentBackgroundFlutterActivity
import java.io.Serializable

const val KEY_ARGS = "_args"

object CustomNavigator : ContainerNavigator {

    override fun create(name: String, arguments: Serializable?, options: Options): Intent? {
        val context = Container.getCurrentActivity() ?: return null

        if (options.isFlutterRoute) {
            // standard
//            Container.getCurrentActivity()?.startActivity(ContainerActivity.build(this, name, arguments))

            // singleTop 模式
//            val intent = ContainerActivity.build(this, name, args, activityClass = SingleTopFlutterActivity::class.java, willTransactionWithAnother = true)
//            Container.getCurrentActivity()?.startActivity(intent)

            // singleTask 模式
            val builder = ContainerActivity.builder(name, arguments, false)

            // 你看到的绿色的闪屏就是这个
            builder.backgroundColor = Color.WHITE
            builder.activityClass = SingleTaskFlutterActivity::class.java

            return builder.build(context);
        }


        when (name) {
            "flutter2native" -> {
                return Intent(context, FlutterToNativeActivity::class.java)
            }
            "native2flutter" -> {
                return Intent(context, Native2FlutterActivity::class.java)
            }
            "tabContainer" -> {
                return Intent(context, TabContainerActivity::class.java)
            }
            else -> {
                val intent = Intent(Intent.ACTION_VIEW)
                intent.data = Uri.parse(name)
                intent.putExtra(KEY_ARGS, arguments)
                return intent
            }
        }

    }

    override fun pop(result: Serializable?) {
        val activity = Container.getCurrentActivity() ?: return
        if (result != null) {
            activity.setResult(Activity.RESULT_OK, Intent().apply { putExtra(KEY_ARGS, result) })
        }
        activity.finish()

        if (activity is TransparentBackgroundFlutterActivity) {
            activity.overridePendingTransition(0, 0)
        }
    }

    override fun enableSwipeBack(enable: Boolean) {

    }
}