import "dart:io";
import 'dart:typed_data';
import 'package:aes256gcm/aes256gcm.dart';
import 'package:cryptography/cryptography.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:fast_rsa/fast_rsa.dart' as fast;
import '../CloudflareWorkers/keys.dart';

Future<File> decryptFiles(
    FilePickerResult result, String email, String password) async {
  File file = File((result.files.first.path).toString());
  var dbConnect = Keys.emailOnly(email);
  Future<Uint8List> imgbytes1 = file.readAsBytes();
  String privKey = await dbConnect.getKeys(1);
  // decrypting the RSA private key using AES-GCM and the password
  privKey = await Aes256Gcm.decrypt(privKey, password);
  // implement XChaCha20-Poly1305 encryption using the cryptography package
  final algorithem = Xchacha20.poly1305Aead();
  // defining variables that will be needed for inside the whenCompleted function
  SecretKey secretKey;
  List<int> Nonce;
  // allow reading of the file to be completed before continuing
  imgbytes1.whenComplete(() async {
    // reading in the file
    final data = await file.readAsBytes();
    // get the encrypted secret key
    final encryptedSecretKey = data.sublist(0, 512);
    // get the encrypted nonce
    final encryptedNonce = data.sublist(512, 1024);
    // get the mac
    final encryptedMac = data.sublist(1024, 1040);
    // get cipherText
    final encryptedFileContents = data.sublist(1040);
    // decrypt the secret key
    final decryptedSecretKey = await fast.RSA.decryptOAEPBytes(
        encryptedSecretKey, "encryptedSecretKey", fast.Hash.SHA512, privKey);
    // decrypt the nonce
    final decryptedNonce = await fast.RSA.decryptOAEPBytes(
        encryptedNonce, "encryptedNonce", fast.Hash.SHA512, privKey);
      // using the decrypted key to create a secretKey object that will be used to decrypt the file
    secretKey = SecretKey(decryptedSecretKey);
    Nonce = decryptedNonce;
    // create new SecretBox object
    SecretBox secretBox = SecretBox(
        encryptedFileContents, mac: Mac(encryptedMac), nonce: Nonce);
    final decrypted = algorithem.decrypt(secretBox, secretKey: secretKey);
    // now, time to write to the file!
    // get the file name
    File outputFile = File(p.join(p.dirname(file.path),p.basenameWithoutExtension(file.path)));
    // write the decrypted contents to the file
    outputFile.writeAsBytes(await decrypted);
    file = outputFile;
    });
  return file;
}
