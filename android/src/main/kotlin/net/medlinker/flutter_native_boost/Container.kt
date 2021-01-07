package net.medlinker.flutter_native_boost

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.fragment.app.FragmentActivity
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint
import io.flutter.plugin.common.MethodChannel
import net.medlinker.flutter_native_boost.channels.CommonChannel
import net.medlinker.flutter_native_boost.channels.NetChannel
import net.medlinker.flutter_native_boost.channels.NetHandler
import java.lang.ref.WeakReference
import java.util.concurrent.atomic.AtomicInteger

object Container {

    private val nextCode = AtomicInteger()

    @JvmStatic
    lateinit var engine: FlutterEngine
        private set

    internal var pluginRef: WeakReference<FNBoostPlugin>? = null
    internal val plugin: FNBoostPlugin?
        get() = pluginRef?.get()

    internal lateinit var navigator: ContainerNavigator

    /**
     *  init engine
     *
     *  @param context Application Context
     *  @param navigator handle native route
     *  @param netHandler handle net request
     *  @param commonHandler common method invoke
     *  @param automaticallyRegisterPlugins If plugins are automatically
     * registered, then they are registered during the execution of this constructor
     *
     *  @return true if plugins registered otherwise return false.
     *
     *  @sample
     *  if (!Container.initEngine(this, MyFlutterNavigator())) {
     *       GeneratedPluginRegister.registerGeneratedPlugins(Container.engine)
     *   }
     *
     */
    @JvmStatic
    fun initEngine(context: Context,
                   navigator: ContainerNavigator,
                   netHandler: NetHandler? = null,
                   commonHandler: MethodChannel.MethodCallHandler? = null,
                   automaticallyRegisterPlugins: Boolean = true,
                   dartEntrypointFunctionName: String = "main"): Boolean {
        // 这个navigator 必须先初始化 不能动
        Container.navigator = navigator
        engine = FlutterEngine(context, null, automaticallyRegisterPlugins)

        val flutterLoader = FlutterInjector.instance().flutterLoader()

        if (!flutterLoader.initialized()) {
            throw AssertionError(
                    "DartEntrypoints can only be created once a FlutterEngine is created.")
        }
        val entrypoint = DartEntrypoint(flutterLoader.findAppBundlePath(), dartEntrypointFunctionName)

        engine.dartExecutor.executeDartEntrypoint(entrypoint)

        if (netHandler != null) {
            NetChannel(engine.dartExecutor, netHandler)
        }

        if (commonHandler != null) {
            CommonChannel(engine.dartExecutor, commonHandler)
        }

        return pluginRef != null
    }

    internal fun genPageId(): Int {
        return nextCode.getAndIncrement()
    }

    /**
     * The current flutter container Activity
     */
    @JvmStatic
    fun getCurrentActivity(): Activity? {
        return plugin?.binding?.activity
    }

    /**
     * start native Activity,and request for Activity result
     */
    internal fun startNativeForResult(intent: Intent, callback: (result: HashMap<String, Any?>?) -> Unit) {
        val code = nextCode.getAndIncrement()
        startNativeForResult(intent, code) { requestCode, resultCode, data ->
            if (requestCode == code) {
                if (resultCode == Activity.RESULT_OK) {
                    val map = hashMapOf<String, Any?>()
                    data?.extras?.keySet()?.forEach {
                        map[it] = data.extras?.get(it)
                    }
                    callback.invoke(map)
                } else {
                    callback.invoke(null)
                }
            }
        }
    }

    private fun startNativeForResult(intent: Intent, requestCode: Int, callback: (requestCode: Int, resultCode: Int, data: Intent?) -> Unit) {
        val activity = getCurrentActivity()

        if (activity is ResultProvider) {
            activity.addResultListener(callback)
            activity.startActivityForResult(intent, requestCode)
            return
        }

        if (activity is FragmentActivity) {
            val frag = activity.supportFragmentManager.fragments.first { it.isVisible }
            if (frag is ResultProvider) {
                frag.addResultListener(callback)
                frag.startActivityForResult(intent, requestCode)
            }
        }
    }
}
