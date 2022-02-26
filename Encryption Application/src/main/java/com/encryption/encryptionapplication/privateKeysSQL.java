package com.encryption.encryptionapplication;

import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;

public class privateKeysSQL {
    private int ID;
    private String created;
    private String email;
    private String name;
    private char sendReceive;
    private String keysValue;
    private static ArrayList<String> emails = new ArrayList<>();
    private static ArrayList<String> names = new ArrayList<>();

    public static void main(String[] args) {
        selectAll();
    }
    public static Connection Connect() {
        Connection conn = null;
        try {
            // database params
            String url = "jdbc:sqlite:src/DB/cerberus.sqlite";
            conn = DriverManager.getConnection(url);
            System.out.println("Connection to SQLite has been established");
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Connection failed");
        }
        return conn;
    }

    public static void insert(String email, String name, String SendRecieve, PrivateKey pvt) {
        String sql = "INSERT INTO PrivateKeys(email, name, SendReceive, Keyvalue) VALUES(?,?,?,?)";

        try{
            Connection conn = Connect();

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2,name);
            pstmt.setString(3,SendRecieve);
            byte[] bytes = pvt.getEncoded();
            pstmt.setBytes(4,bytes);
            pstmt.executeUpdate();
            // conn.commit();
            conn.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public static void selectAll(){
        String sql = "SELECT * FROM PrivateKeys";

        try {
            Connection conn = Connect();
            Statement stmt1  = conn.createStatement();
            ResultSet rs    = stmt1.executeQuery(sql);
            System.out.println(rs);
            // loop through the result set
            while (rs.next()) {
                System.out.println(rs.getInt("id") +  "\t" + rs.getTimestamp("created_at") + "\t" + rs.getString("email") +
                        rs.getString("name") + "\t" +
                        rs.getString("SendReceive") + rs.getByte("Keyvalue"));
            }
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // updating arraylist values
    public static void idArrayUpdater() {
        String sql = "SELECT * FROM PrivateKeys;";
        emails.clear();
        names.clear();
        try {
            Connection conn = Connect();
            Statement stm = conn.createStatement();
            ResultSet rs = stm.executeQuery(sql);
            System.out.println(rs);
            // compiling all the ids (email and name)
            while (rs.next()) {
                emails.add(rs.getString("email"));
                names.add(rs.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // getting private key value based on user input
    public static PrivateKey getPrivateKeyValue (StringBuilder email) throws InvalidKeySpecException, NoSuchAlgorithmException {
        String sql = "SELECT Keyvalue FROM PrivateKeys WHERE email LIKE '" + email + "%';";

        byte[] bytes = null;

        try {
            Connection conn = Connect();
            Statement stm1 = conn.createStatement();
            ResultSet rs = stm1.executeQuery(sql);
            System.out.println(rs);
            // saving result
            bytes = rs.getBytes("Keyvalue");
            conn.close();
        }
        catch (SQLException e) {
            System.out.println("SQL error");
            e.printStackTrace();
        }
        catch (Exception e) {
            System.out.println("General exception");
            e.printStackTrace();
        }
        // setting up private key value for use
        PKCS8EncodedKeySpec ksPvt = new PKCS8EncodedKeySpec(bytes);
        KeyFactory kfPvt = KeyFactory.getInstance("RSA");
        return kfPvt.generatePrivate(ksPvt);
    }

    // returning emails and names to compile choice list
    public static ArrayList<String> getEmails() {
        return emails;
    }

    public static ArrayList<String> getNames() {
        return names;
    }
}
