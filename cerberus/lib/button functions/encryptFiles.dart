import "dart:io";
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:cryptography/cryptography.dart';
import 'package:fast_rsa/fast_rsa.dart' as fast;
import '../CloudflareWorkers/keys.dart';

Future<File> encryptFile(FilePickerResult result, String email) async {
  File file = File((result.files.first.path).toString());
  var dbConnect = Keys.emailOnly(email);
  Uint8List imgbytes1 = await file.readAsBytes();
  String pubKey = await dbConnect.getKeys(0);
  // implement XChaCha20-Poly1305 encryption using the cryptography package
  final algorithem = Xchacha20.poly1305Aead();
  final secretKey = await algorithem.newSecretKey();
  final nonce = algorithem.newNonce();
  final encrypted = await algorithem.encrypt(
    imgbytes1,
    secretKey: secretKey,
    nonce: nonce,
  );
  // encrypt secretkeybytes with rsa
  final temp = await secretKey.extractBytes();
  // convert List<Int> to Uint8List
  Uint8List keyBytes = Uint8List.fromList(temp);
  final encryptedSecretKey = await fast.RSA.encryptOAEPBytes(
      keyBytes, "encryptedSecretKey", fast.Hash.SHA512, pubKey);
  // get the directory of file
  var outputFile =
      File(p.join(p.dirname(file.path), p.basename(file.path) + ".cerb"));
  // write encryptedSecretKey along with nonce and MAC to outputFile
  await outputFile.writeAsBytes(encryptedSecretKey);
  final nonceBytes = Uint8List.fromList(nonce);
  final encryptedNonce = await fast.RSA
      .encryptOAEPBytes(nonceBytes, "encryptedNonce", fast.Hash.SHA512, pubKey);
  await outputFile.writeAsBytes(encryptedNonce, mode: FileMode.append);
  // append MAC to the file
  await outputFile.writeAsBytes(encrypted.mac.bytes, mode: FileMode.append);
  // append cipherText to the file
  await outputFile.writeAsBytes(encrypted.cipherText, mode: FileMode.append);
  return outputFile;
  /*
    final AESkey = encrypt.Key.fromSecureRandom(32);
    final AESiv = encrypt.IV.fromSecureRandom(16);
    final encryptor =
        encrypt.Encrypter(encrypt.AES(AESkey, mode: encrypt.AESMode.gcm));
    // @bug: some weird thing when I tested using a 6.5mb pdf file. When I did the encryption on the imgbytes1, the bytes balloned to 35mb...
    // @bug: I need to fix the variable names on both encryption and decryption. For example, somehow encryptedAESKEy and encryptedFileContents are the same? It's interesting.... Need to spend time to figure out and change variable names! But I think using binary is good and will allow me to encrypt and decrypt virtually any file type

    final encrypted = encryptor.encryptBytes(imgbytes1, iv: AESiv);
    // get the directory of file
    var outputFile =
        File(p.join(p.dirname(file.path), p.basename(file.path) + ".cerb"));
    // encrypt AESkey with pubkey
    final encryptedAESKey =
        await RSA.encryptOAEPBytes(AESkey.bytes, "Key", Hash.SHA512, pubKey);
    final encryptedAESIV =
        await RSA.encryptOAEPBytes(AESiv.bytes, "IV", Hash.SHA512, pubKey);
    // write encryptedAESKey and encryptedAESIV to outputFile
    outputFile.writeAsBytesSync(encryptedAESKey);
    outputFile.writeAsBytesSync(
      encryptedAESIV,
      mode: FileMode.append,
    );
    // write encrypted to outputFile
    outputFile.writeAsBytesSync(encrypted.bytes, mode: FileMode.append);
    return file;
    */
}
