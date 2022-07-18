package com.company.test.encryption;


import javax.crypto.*;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

public class Main {
    private static final File inputFile = Paths.get("external-content.duckduckgo.com.jpg").toFile();
    private static SecretKey key;
    private static IvParameterSpec spec;
    private static final String algorithm = "AES/CBC/PKCS5Padding";
    private static final String pubKeyFile = "John doe.pub";
    private static final String pvtKeyFile = "John doe.key";

    public static void main (String[] args) throws java.security.NoSuchAlgorithmException,
            java.security.InvalidAlgorithmParameterException,
            java.security.InvalidKeyException,
            java.security.spec.InvalidKeySpecException,
            javax.crypto.NoSuchPaddingException,
            javax.crypto.BadPaddingException,
            javax.crypto.IllegalBlockSizeException,
            java.io.IOException {

        // Generating AES Keys

        AESGen();

        // Generating and SAVING RSA Keys

       // RSAGen();

        // Encrypting file

       Encrypt();

        //Decrypting file

//       Decrypt();


    }

    private static void Decrypt() throws IOException, NoSuchAlgorithmException, InvalidKeySpecException, NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException {
        // Loading RSA Private Key

        byte[] bytesPvt = Files.readAllBytes(Paths.get(pvtKeyFile));
        PKCS8EncodedKeySpec ksPvt = new PKCS8EncodedKeySpec(bytesPvt);
        KeyFactory kfPvt = KeyFactory.getInstance("RSA");
        PrivateKey pvt = kfPvt.generatePrivate(ksPvt);

        // Load the AES key
        FileInputStream in = new FileInputStream(inputFile + ".enc");
        Cipher cipherPvt = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        cipherPvt.init(Cipher.DECRYPT_MODE, pvt);
        byte[] x = new byte[512];
        in.read(x);
        byte[] keyb = cipherPvt.doFinal(x);
        SecretKeySpec skey = new SecretKeySpec(keyb, "AES");

        // reading the IV
        byte[] iv = new byte[16];
        in.read(iv);
        IvParameterSpec ivspec = new IvParameterSpec(iv);

        // decrypting file

        Cipher decrypt = Cipher.getInstance(algorithm);
        decrypt.init(Cipher.DECRYPT_MODE, skey, ivspec);
        try (FileOutputStream out = new FileOutputStream(inputFile+".ver")){
            processFile(decrypt, in, out);
        }

    }

    private static void Encrypt() throws IOException, NoSuchAlgorithmException, InvalidKeySpecException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeyException, InvalidAlgorithmParameterException {
        // loading RSA public key from file
        byte[] bytesPub = Files.readAllBytes(Paths.get(pubKeyFile));
        X509EncodedKeySpec ksPub = new X509EncodedKeySpec(bytesPub);
        KeyFactory kfPub = KeyFactory.getInstance("RSA");
        PublicKey pub = kfPub.generatePublic(ksPub);

        // Saving AES key to the file
        FileOutputStream output = new FileOutputStream(inputFile + ".enc");
        Cipher cipherPub = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        cipherPub.init(Cipher.ENCRYPT_MODE, pub);
        byte[] b = cipherPub.doFinal(key.getEncoded());
        System.out.println(b.length);
        output.write(b);

        // writing IV to file as well
        output.write(spec.getIV());

        // encrypting contents of file using AES
        Cipher ci = Cipher.getInstance(algorithm);
        ci.init(Cipher.ENCRYPT_MODE, key, spec);
        try (FileInputStream in = new FileInputStream(inputFile)) {
            processFile(ci, in, output);
        }
    }

    private static void RSAGen() throws NoSuchAlgorithmException, IOException {
        RSA keysAsync = new RSA();
        keysAsync.generateKeyPair();
    }

    private static void AESGen() throws NoSuchAlgorithmException {
        spec = AES.generateIv();
        key = AES.generateKey();
    }


    private static void processFile(Cipher ci, InputStream in, OutputStream out) throws javax.crypto.IllegalBlockSizeException, javax.crypto.BadPaddingException, java.io.IOException
    {
        byte[] ibuf = new byte[1024];
        int len;
        while ((len = in.read(ibuf)) != -1) {
            byte[] obuf = ci.update(ibuf, 0, len);
            if ( obuf != null ) out.write(obuf);
        }
        byte[] obuf = ci.doFinal();
        if ( obuf != null ) out.write(obuf);
    }
    private static void processFile(Cipher ci,String inFile,String outFile) throws javax.crypto.IllegalBlockSizeException,javax.crypto.BadPaddingException,java.io.IOException
    {
        try (FileInputStream in = new FileInputStream(inFile);
             FileOutputStream out = new FileOutputStream(outFile)) {
            processFile(ci, in, out);
        }
    }


}
