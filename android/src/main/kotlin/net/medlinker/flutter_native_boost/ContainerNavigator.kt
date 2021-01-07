package net.medlinker.flutter_native_boost

import android.content.Intent
import java.io.Serializable

data class Options(val raw: HashMap<String, *>?) {

    val animated: Boolean
        get() = get("_container.animated", true)

    val present: Boolean
        get() = get("_container.present", false)

    val isFlutterRoute: Boolean
        get() = get("_container.flutter", false)

    inline fun <reified T> get(key: String, defaultValue: T): T {
        if (raw == null) return defaultValue
        val value = raw[key]
        if (value is T) return value;
        return defaultValue
    }
}

interface ContainerNavigator {

    /**
     * create native Intent
     */
    fun create(name: String, arguments: Serializable?, options: Options): Intent?

    /**
     * finish flutter container Activity
     */
    fun pop(result: Serializable?)

    /**
     * 是否允许滑动返回
     */
    fun enableSwipeBack(enable: Boolean)
}
