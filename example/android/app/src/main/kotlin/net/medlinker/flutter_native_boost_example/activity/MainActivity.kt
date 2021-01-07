package net.medlinker.flutter_native_boost_example.activity

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import net.medlinker.flutter_native_boost_example.R
import net.medlinker.flutter_native_boost_example.activity.splash.FirstFlutterActivity

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    override fun onStart() {
        super.onStart()

        // 跳转到 flutter `home` 路由
        val intent = FirstFlutterActivity.build(this)

        // 直接打开flutter 页面
        startActivity(intent)

        //
        finish()

        // 阻止动画
        overridePendingTransition(0, 0)

    }
}
