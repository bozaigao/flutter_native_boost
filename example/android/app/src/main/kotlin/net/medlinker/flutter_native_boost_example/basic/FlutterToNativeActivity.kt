package net.medlinker.flutter_native_boost_example.basic

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import net.medlinker.flutter_native_boost_example.R
import java.util.*

class FlutterToNativeActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_flutter2native)
        findViewById<Button>(R.id.btn).setOnClickListener {
            val intent = Intent()
            intent.putExtra("date", Date().toString())
            setResult(RESULT_OK, intent)
            finish()
        }
        actionBar?.title = "Flutter2Native"
    }

}