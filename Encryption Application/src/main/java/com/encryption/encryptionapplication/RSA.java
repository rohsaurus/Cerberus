package com.encryption.encryptionapplication;

import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
public class RSA {

private static PublicKey pub;
private static PrivateKey pvt;
    public static void generateKeyPair(String fileName) throws NoSuchAlgorithmException, IOException {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("RSA");
        kpg.initialize(4096);
        KeyPair kp = kpg.generateKeyPair();
        pub = kp.getPublic();
        pvt = kp.getPrivate();
        try (FileOutputStream out = new FileOutputStream(fileName + ".key")) {
            out.write(kp.getPrivate().getEncoded());
        }

        try (FileOutputStream out = new FileOutputStream(fileName + ".pub")) {
            out.write(kp.getPublic().getEncoded());
        }
    }
    public static void restorePublicKey(String pubKeyFile) throws InvalidKeySpecException, NoSuchAlgorithmException, IOException {
        byte[] bytes = Files.readAllBytes(Paths.get(pubKeyFile));
        X509EncodedKeySpec ks = new X509EncodedKeySpec(bytes);
        KeyFactory kf = KeyFactory.getInstance("RSA");
        pub = kf.generatePublic(ks);
    }
    public static void restorePrivateKey(String pvtKeyFile) throws IOException, NoSuchAlgorithmException, InvalidKeySpecException {
        byte[] bytes = Files.readAllBytes(Paths.get(pvtKeyFile));
        PKCS8EncodedKeySpec ks = new PKCS8EncodedKeySpec(bytes);
        KeyFactory kf = KeyFactory.getInstance("RSA");
        pvt = kf.generatePrivate(ks);
    }

    public static PublicKey getPub() {
        return pub;
    }

    public static PrivateKey getPvt() {
        return pvt;
    }
}