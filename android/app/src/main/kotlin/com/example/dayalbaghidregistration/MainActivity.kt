package com.example.dayalbaghidregistration

import android.view.WindowManager.LayoutParams
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build
import android.os.SystemClock
import android.telephony.TelephonyManager
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import com.mantra.mfs100.FingerData
import com.mantra.mfs100.MFS100
import com.mantra.mfs100.MFS100Event
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.lang.Exception
import androidx.core.app.ActivityCompat

import androidx.core.content.ContextCompat
import java.util.jar.Manifest
import kotlin.math.log


class MainActivity: FlutterActivity() , MFS100Event {
    private val mLastClkTime: Long = 0
    private val Threshold: Long = 1500

    enum class ScannerAction {
        Capture, Verify
    }

    private val REQUEST_READ_PHONE_STATE = 1;
    lateinit var Enroll_Template: ByteArray
    lateinit var Verify_Template: ByteArray
    private var lastCapFingerData: FingerData? = null
    var scannerAction = ScannerAction.Capture

    var timeout = 10000
    var mfs100: MFS100? = null


    private var isCaptureRunning = false
    private var iso1= ByteArray(0)
    private var iso2 = ByteArray(0)
    private var byteArray2 = ByteArray(0)
    private var byteArray1 = ByteArray(0)
    private var nfiq1:Int? = null
    private var nfiq2:Int? = null
    private var image: Byte? = null;
    private val CHANNEL = "com.example.dayalbaghidregistration/getBitmap";
    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        window.addFlags(LayoutParams.FLAG_SECURE)
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.getDartExecutor(),
            CHANNEL
        ).setMethodCallHandler { call, result ->
            // Note: this method is invoked on the main thread.
            // TODO
            when(call.method){

                "init" ->{
//                    Log.e("result","");
//                    result.success(1);
//                    var ret = InitScanner(context)//
//                    Log.e("result","$ret");
                    result.success(onStart(this))
                }

                "autoCapture" ->{
                    mfs100!!.Init()
                    val map = call.arguments as Map<String, Any>
                    val fingerData=FingerData()
                    val ret= mfs100!!.AutoCapture(fingerData, map["timeout"] as Int,map["detectFinger"] as Boolean)

                    if (ret==0){

                        val data=HashMap<String,Any>()
                        data["finger_image"]=fingerData.FingerImage()
                        data["quality"]=fingerData.Quality()
                        data["nfiq"]=fingerData.Nfiq()
                        data["raw_data"]=fingerData.RawData()
                        data["iso_template"]=fingerData.ISOTemplate()
                        data["in_width"]=fingerData.InWidth()
                        data["in_height"]=fingerData.InHeight()
                        data["in_area"]=fingerData.InArea()
                        data["resolution"]=fingerData.Resolution()
                        data["greyscale"]=fingerData.GrayScale()
                        data["bpp"]=fingerData.Bpp()
                        data["wsq_compress_ratio"]=fingerData.WSQCompressRatio()
                        data["wsq_info"]=fingerData.WSQInfo()

                        result.success(data)

                    }else{
                        Log.e("error",mfs100!!.GetErrorMsg(ret))
                        result.error(ret.toString(),mfs100!!.GetErrorMsg(ret),null)
                    }

                }

                "matchISO" ->{
                    val map = call.arguments as Map<*, *>
                    val ret= mfs100!!.MatchISO(map["firstTemplate"] as ByteArray ,map["secondTemplate"] as ByteArray)
                    result.success(ret)
                }

                "stopAutoCapture" ->{

                    result.success(mfs100!!.StopAutoCapture())
                }

                "getPlatformVersion" ->{
                    result.success(0)
                }

                "getErrorMessage" ->{
                    val map = call.arguments as Map<*, *>
                    result.success(mfs100!!.GetErrorMsg(map["error"] as Int))
                }

                "dispose" ->{
                    mfs100!!.Dispose()
                }
                "getPhoneData"-> {

                var m:MutableMap<String, String> = mutableMapOf();
                val manager: TelephonyManager =
                    context.getSystemService(TELEPHONY_SERVICE) as TelephonyManager
                val carrierName: String = manager.getNetworkOperatorName()
                Log.d("carrier",carrierName)
                val permissionCheck =
                    ContextCompat.checkSelfPermission(this, android.Manifest.permission.READ_PHONE_STATE)

                if (permissionCheck != PackageManager.PERMISSION_GRANTED) {
                    ActivityCompat.requestPermissions(
                        this,
                        arrayOf(android.Manifest.permission.READ_PHONE_STATE),
                        REQUEST_READ_PHONE_STATE
                    )
                } else {
                    val imei = manager.imei
                    m["imei"] = imei;
//                    try{
//                    val data = manager.isDataEnabled
//                    m["data"] = data.toString()}
//                    catch (e:Exception){
//
//                    }
                }
                val deviceModel = Build.MODEL
                val deviceBrand = Build.BRAND

                m["phoneBrand"]=deviceBrand;
                m["phoneModel"] = deviceModel
                m["carrier"] = carrierName;
                result.success(m);


            }
                "unInit" ->{
                    result.success(mfs100!!.UnInit())
                }

                else -> result.notImplemented()

            }
//            if (call.method == "startReading1") {
//
//                InitScanner(this);
//                byteArray1 = ByteArray(0);
//                StartSyncCapture(1);
//                //result.success(list);
//                //MFS100Test().Stop();
//
//            }else if(call.method == "startReading2"){
//                InitScanner(this);
//                byteArray2 = ByteArray(0);
//                StartSyncCapture(2);
//            }
//            else if(call.method == "firstFingerPrint"){
//                Stop()
//                result.success(byteArray1)
//            }
//            else if(call.method == "secondFingerPrint"){
//                Stop()
//                result.success(byteArray2)
//            }
//            else if (call.method == "getPhoneData") {
//
//                var m:MutableMap<String, String> = mutableMapOf();
//                val manager: TelephonyManager =
//                    context.getSystemService(TELEPHONY_SERVICE) as TelephonyManager
//                val carrierName: String = manager.getNetworkOperatorName()
//                Log.d("carrier",carrierName)
//                val permissionCheck =
//                    ContextCompat.checkSelfPermission(this, android.Manifest.permission.READ_PHONE_STATE)
//
//                if (permissionCheck != PackageManager.PERMISSION_GRANTED) {
//                    ActivityCompat.requestPermissions(
//                        this,
//                        arrayOf(android.Manifest.permission.READ_PHONE_STATE),
//                        REQUEST_READ_PHONE_STATE
//                    )
//                } else {
//                    val imei = manager.imei
//                    m["imei"] = imei;
////                    try{
////                    val data = manager.isDataEnabled
////                    m["data"] = data.toString()}
////                    catch (e:Exception){
////
////                    }
//                }
//                val manufacturer = Build.MANUFACTURER
//                val deviceModel = Build.MODEL
//                val deviceBrand = Build.BRAND
//
//                m["phoneBrand"]=deviceBrand;
//                m["phoneModel"] = deviceModel
//                m["carrier"] = carrierName;
//                result.success(m);
//
//
//            }
//            else if(call.method == "getFingerprint") {
//                val ret = mfs100?.MatchISO(iso1, iso2);
//                if (ret != null) {
//                    if (ret >= 0) {
//                        if (ret >= 96) {
//                            if (nfiq1!! > nfiq2!!) {
//                                result.success(byteArray2)
//                            } else if (nfiq2!! > nfiq1!!) {
//                                result.success(byteArray1)
//                            }
//                        } else {
//                            Log.d("finger","not matched")
//                            var bytearray = ByteArray(0);
//                            bytearray = "Finger not matched".toByteArray()
//                            result.success(bytearray)
//                        }
//                    } else{var bytearray = ByteArray(0);
//                        bytearray = (mfs100?.GetErrorMsg(ret)).toString().toByteArray()
//                        result.success(bytearray)}
//
//                };
//            }
//            else if(call.method == "initialiseReader"){
//                onStart(this);
//
////                result.success(code);
//
//            }
//            else {
//                result.notImplemented()
//            }
        }
    }

    protected fun onStart(mCOntext: Context):Int {
        try {

            mfs100 = MFS100(this)
            Log.d("starting","$mfs100");
            mfs100!!.SetApplicationContext(mCOntext)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        try {
            if (mfs100 == null) {
                mfs100 = MFS100(this)
                mfs100!!.SetApplicationContext(mCOntext)
            } else {
                 InitScanner(mCOntext)
            }
            return 1;
        } catch (e: Exception) {
            e.printStackTrace()
            return -1;
        }

    }

    protected fun Stop() {
        try {
            if (isCaptureRunning) {
                Log.d("stopping","stopped");
                val ret = mfs100!!.StopAutoCapture()
            }
            Thread.sleep(500)
            UnInitScanner()
        } catch (e: InterruptedException) {
            e.printStackTrace()
        }
    }


    private fun InitScanner(context: Context):Int{
         try {

            val ret = mfs100!!.Init()
             Log.d("error","$ret")
            if (ret != 0) {
                val x = mfs100!!.GetErrorMsg(ret)
                Log.d("error","$x $ret")
            } else {
                """Serial: ${mfs100!!.GetDeviceInfo().SerialNo()} Make: ${
                    mfs100!!.GetDeviceInfo().Make()
                } Model: ${mfs100!!.GetDeviceInfo().Model()}
Certificate: ${mfs100!!.GetCertification()}"""

            }
             return ret;
        } catch (ex: Exception) {
            "exception"
             return -1;
        }

    }

    protected fun StartSyncCapture(index:Int) {
        Thread{
            //  SetTextOnUIThread("");
            isCaptureRunning = true
            try {
                val fingerData = FingerData()
                val ret = mfs100!!.AutoCapture(fingerData, timeout, true)
                Log.e("StartSyncCapture.RET", "" +ret+ mfs100!!.GetErrorMsg(ret))
                if(ret == -1324) {
                    val strError = mfs100!!.GetErrorMsg(ret);
                    if(index == 1)
                        byteArray1 = strError.toByteArray()
                    else if(index == 2)
                        byteArray2 = strError.toByteArray()
                }
                else if(ret == -1307) {
                    val strError = mfs100!!.GetErrorMsg(ret);
                    if(index == 1)
                        byteArray1 = strError.toByteArray()
                    else if(index == 2)
                        byteArray2 = strError.toByteArray()
                }
                else if(ret == -1319){
                    val strError = mfs100!!.GetErrorMsg(ret);
                    if(index == 1)
                        byteArray1 = strError.toByteArray()
                    else if(index == 2)
                        byteArray2 = strError.toByteArray()
                }
                if (ret != 0) {
                    //   SetTextOnUIThread(mfs100.GetErrorMsg(ret));
                } else {
                    lastCapFingerData = fingerData
//                    val bitmap = BitmapFactory.decodeByteArray(
//                        fingerData.FingerImage(), 0,
//                        fingerData.FingerImage().size
//                    )
//                    val stream = ByteArrayOutputStream()
//                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
//                    byteArray = stream.toByteArray()
//                    bitmap.recycle()
                    Log.d("nfiq","${fingerData.Nfiq()}");
                    if(index == 1) {
                        nfiq1 = fingerData.Nfiq()
                        byteArray1 = if (fingerData.Nfiq() > 3)
                            "bad image".toByteArray()
                        else
                            fingerData.FingerImage();
                        iso1 = fingerData.ISOTemplate()
                    }
                    else if(index == 2) {
                        nfiq2 = fingerData.Nfiq()
                        byteArray2 = if (fingerData.Nfiq() > 3)
                            "bad image".toByteArray()
                        else
                            fingerData.FingerImage();
                        iso2 = fingerData.ISOTemplate()
                    }

                }
            } catch (ex: Exception) {

            } finally {
                isCaptureRunning = false
            }}.start();


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
        Log.d("devic attched","yes");
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