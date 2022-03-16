// import 'package:crypto/crypto.dart';
// import 'package:encrypt/encrypt.dart';

class Keys {
  List<String> allowedSHAFingerprints = [
    "cf3809f502af22fd904d59412fc5a373bf74a2166b3ce6cdc60d3d6c1681e9e5"
  ];
}
// class KeyEncrypt {
//   static Encrypted? encrypted;
//   static var decrypted;

//   String encryptAES(token) {
//     final key = Key.fromUtf8('y32lengthsupersecretnooneknows1q');
//     final iv = IV.fromLength(16);
//     final encrypter = Encrypter(AES(key));
//     encrypted = encrypter.encrypt(token, iv: iv);
//     return (encrypted!.base64);
//   }

//   String decryptAES(token) {
//     final key = Key.fromUtf8('y32lengthsupersecretnooneknows1q');
//     final iv = IV.fromLength(16);
//     final encrypter = Encrypter(AES(key));
//     decrypted = encrypter.decrypt(token!, iv: iv);
//     return (decrypted);
//   }
// }
