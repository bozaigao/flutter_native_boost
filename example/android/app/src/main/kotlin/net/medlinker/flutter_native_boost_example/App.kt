package net.medlinker.flutter_native_boost_example

import android.app.Application
import net.medlinker.flutter_native_boost.Container
import net.medlinker.flutter_native_boost_example.navigator.CustomNavigator

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        Container.initEngine(this, CustomNavigator)
    }
}
