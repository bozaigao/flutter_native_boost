package net.medlinker.flutter_native_boost_example.basic

import android.content.Intent
import android.os.Bundle
import android.widget.RadioButton
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import net.medlinker.flutter_native_boost.ContainerFragment
import net.medlinker.flutter_native_boost_example.R
import net.medlinker.flutter_native_boost_example.fragment.TestFragment

class TabContainerActivity : AppCompatActivity() {

    private var tempFragment: Fragment? = null
    private val flutterFrag1 = ContainerFragment.newInstance("tab1")
    private val flutterFrag2 = ContainerFragment.newInstance("home")
    private val nativeFrag1 = TestFragment.newInstance("native fragment 1")
    private val nativeFrag2 = TestFragment.newInstance("native fragment 2")

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_tab_container)

        val tab1 = findViewById<RadioButton>(R.id.tab1)
        val tab2 = findViewById<RadioButton>(R.id.tab2)
        val tab3 = findViewById<RadioButton>(R.id.tab3)
        val tab4 = findViewById<RadioButton>(R.id.tab4)

        tab1.setOnClickListener { switchFragment(flutterFrag1, "F1") }
        tab2.setOnClickListener { switchFragment(nativeFrag1, "N1") }
        tab3.setOnClickListener { switchFragment(flutterFrag2, "F2") }
        tab4.setOnClickListener { switchFragment(nativeFrag2, "N2") }

        switchFragment(flutterFrag1, "F1")
    }

    private fun switchFragment(fragment: Fragment, tag: String) {
        if (tempFragment == fragment) return
        if (tag == "F2") {
            supportActionBar?.hide()
        } else {
            supportActionBar?.show()
        }
        val transaction = supportFragmentManager.beginTransaction()
        if (!fragment.isAdded) {
            transaction.add(R.id.fragment_container, fragment, tag)
        }
        transaction.show(fragment)
        tempFragment?.let { transaction.hide(it) }
//        transaction.replace(R.id.frag, fragment)
//        transaction.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_OPEN)
//        transaction.addToBackStack(null)
        tempFragment = fragment
        transaction.commitNow()
    }

    override fun onTrimMemory(level: Int) {
        super.onTrimMemory(level)
        if (tempFragment is ContainerFragment) {
            (tempFragment as ContainerFragment).onTrimMemory(level)
        }
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        if (tempFragment is ContainerFragment) {
            (tempFragment as ContainerFragment).onUserLeaveHint()
        }
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        if (tempFragment is ContainerFragment && intent != null) {
            (tempFragment as ContainerFragment).onNewIntent(intent)
        }
    }

    override fun onPostResume() {
        super.onPostResume()
        if (tempFragment is ContainerFragment) {
            (tempFragment as ContainerFragment).onPostResume()
        }
    }

    override fun onBackPressed() {
        if (tempFragment is ContainerFragment) {
            (tempFragment as ContainerFragment).onBackPressed()
        } else {
            super.onBackPressed()
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (tempFragment is ContainerFragment) {
            (tempFragment as ContainerFragment).onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }
}