package com.example.dayalbaghidregistration

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.SystemClock
import android.util.Log
import androidx.annotation.NonNull
import com.mantra.mfs100.FingerData
import com.mantra.mfs100.MFS100
import com.mantra.mfs100.MFS100Event
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.lang.Exception

class MainActivity: FlutterActivity() , MFS100Event {
    private val mLastClkTime: Long = 0
    private val Threshold: Long = 1500

    enum class ScannerAction {
        Capture, Verify
    }

    lateinit var Enroll_Template: ByteArray
    lateinit var Verify_Template: ByteArray
    private var lastCapFingerData: FingerData? = null
    var scannerAction = ScannerAction.Capture

    var timeout = 10000
    var mfs100: MFS100? = null


    private var isCaptureRunning = false

    private var byteArray = ByteArray(0)
    private var image: Byte? = null;
    private val CHANNEL = "com.example.dayalbaghidregistration/getBitmap";
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.getDartExecutor(),
            CHANNEL
        ).setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread.
            // TODO

            if (call.method == "startReading") {
//                isbusy = false;
//                RFIDReader.CreateBT4Conn("BTR-8L020080005", this)
//                //Rfid_BT4_Init("BTR-8L020080005",this)
//                GetEpc()
               // MFS100Test().onStart(this);
//                //RFIDReader.CloseConn(connParam)
//

                StartSyncCapture();
                //result.success(list);
                //MFS100Test().Stop();

            }
            else if(call.method == "getFingerprint"){
                result.success(byteArray)
                mfs100?.StopAutoCapture()
            }
            else if(call.method == "initialiseReader"){
                val code = onStart(this);
//                result.success(code);

            }
            else {
                result.notImplemented()
            }
        }
    }

    protected fun onStart(mCOntext: Context): String? {
        try {
            mfs100 = MFS100(this)
            mfs100!!.SetApplicationContext(mCOntext)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        try {
            if (mfs100 == null) {
                mfs100 = MFS100(this)
                mfs100!!.SetApplicationContext(mCOntext)
            } else {
                return InitScanner(mCOntext)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return "not init 1"
    }

    protected fun Stop() {
        try {
            if (isCaptureRunning) {
                val ret = mfs100!!.StopAutoCapture()
            }
            Thread.sleep(500)
            UnInitScanner()
        } catch (e: InterruptedException) {
            e.printStackTrace()
        }
    }


    private fun InitScanner(context: Context): String? {
        return try {
            val ret = mfs100!!.Init()
            if (ret != 0) {
                mfs100!!.GetErrorMsg(ret)
            } else {
                """Serial: ${mfs100!!.GetDeviceInfo().SerialNo()} Make: ${
                    mfs100!!.GetDeviceInfo().Make()
                } Model: ${mfs100!!.GetDeviceInfo().Model()}
Certificate: ${mfs100!!.GetCertification()}"""
            }
        } catch (ex: Exception) {
            "exception"
        }
    }

    protected fun StartSyncCapture() {


            //  SetTextOnUIThread("");
            isCaptureRunning = true
            try {
                val fingerData = FingerData()
                val ret = mfs100!!.AutoCapture(fingerData, timeout, true)
                Log.e("StartSyncCapture.RET", "" + ret)

                if (ret != 0) {
                    //   SetTextOnUIThread(mfs100.GetErrorMsg(ret));
                } else {
                    lastCapFingerData = fingerData
                    val bitmap = BitmapFactory.decodeByteArray(
                        fingerData.FingerImage(), 0,
                        fingerData.FingerImage().size
                    )
                    val stream = ByteArrayOutputStream()
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                    byteArray = stream.toByteArray()
                    bitmap.recycle()

                    //
                }
            } catch (ex: Exception) {

            } finally {
                isCaptureRunning = false
            }


    }

    private fun StopCapture() {
        try {
            mfs100!!.StopAutoCapture()
        } catch (e: Exception) {
            //  ("Error");
        }
    }


    private fun UnInitScanner() {
        try {
            val ret = mfs100!!.UnInit()
        } catch (e: Exception) {
            Log.e("UnInitScanner.EX", e.toString())
        }
    }

    private fun showSuccessLog(key: String) {
        try {
            val info = """
Key: $key
Serial: ${mfs100!!.GetDeviceInfo().SerialNo()} Make: ${
                mfs100!!.GetDeviceInfo().Make()
            } Model: ${mfs100!!.GetDeviceInfo().Model()}
Certificate: ${mfs100!!.GetCertification()}"""
        } catch (e: Exception) {
        }
    }

    private var mLastAttTime = 0L
    var s: String? = null
    override fun OnDeviceAttached(vid: Int, pid: Int, hasPermission: Boolean) {
        if (SystemClock.elapsedRealtime() - mLastAttTime < Threshold) {
            return
        }
        mLastAttTime = SystemClock.elapsedRealtime()
        val ret: Int
        if (!hasPermission) {
            return
        }
        try {
            if (vid == 1204 || vid == 11279) {
                if (pid == 34323) {
                    ret = mfs100!!.LoadFirmware()
                    s = if (ret != 0) mfs100!!.GetErrorMsg(ret) else "firmware load success"
                } else if (pid == 4101) {
                    val key = "Without Key"
                    ret = mfs100!!.Init()
                    if (ret == 0) {
                        showSuccessLog(key)
                    } else {
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
    var mLastDttTime = 0L
    override fun OnDeviceDetached() {
        try {
            if (SystemClock.elapsedRealtime() - mLastDttTime < Threshold) {
                return
            }
            mLastDttTime = SystemClock.elapsedRealtime()
            UnInitScanner()
        } catch (e: Exception) {
        }
    }

    override fun OnHostCheckFailed(err: String?) {
        try {
        } catch (ignored: Exception) {
        }
    }

}