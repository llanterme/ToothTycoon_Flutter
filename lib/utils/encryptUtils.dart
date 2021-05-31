import 'package:encrypt/encrypt.dart';

class EncryptUtils {
  static Future<String> encryptText(String text) async {
    Key key = Key.fromUtf8('o5ucjegrx74cwggosw8scg8oo4skwggJ');
    IV iv = IV.fromUtf8('h67yflxjrbscog4s');
    Encrypter encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    Encrypted encrypted = encrypter.encrypt(text, iv: iv);
    print('Original Text : $text');
    print('Encrypted Text : ${encrypted.base64}');
    return encrypted.base64;
  }

  static Future<String> decryptText(String encryptedText) async {
    Key key = Key.fromUtf8('o5ucjegrx74cwggosw8scg8oo4skwggJ');
    IV iv = IV.fromUtf8('h67yflxjrbscog4s');
    Encrypter encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    String decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: iv);
    print('Encrypted Text : $encryptedText');
    print('Decrypted Text : $decrypted');
    return decrypted;
  }
}
