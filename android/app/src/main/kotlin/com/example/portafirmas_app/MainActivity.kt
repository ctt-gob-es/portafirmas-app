package es.gob.afirma.android.signfolder

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

}
/*
class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "es.gob.portafirmas/sign").setMethodCallHandler {
                call, result ->

            if (call.method == "encrypt") {
                val textToEncode = call.arguments as ByteArray

                val certificateSigner = CertificateSigner()

                certificateSigner.signWithCertificate(
                    data = textToEncode,
                    activity = this,
                    onError = {
                            error -> result.error(error.toString(),null,null)
                    },
                    onSuccess = {
                            bytes, cert, _ ->
                        val resultMap: HashMap<String,Any> = HashMap()

                        resultMap["signedText"] = bytes
                        resultMap["publicKey"] = cert.encoded

                        result.success(resultMap)
                    }

                )
            } else {
                result.notImplemented()
            }
        }
    }

}*/
