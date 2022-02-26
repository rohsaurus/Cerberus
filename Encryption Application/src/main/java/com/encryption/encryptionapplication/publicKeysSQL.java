package com.encryption.encryptionapplication;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class publicKeysSQL {
    private int ID;
    private String created;
    private String email;
    private String name;
    private char sendReceive;
    private String keysValue;
   private static final ArrayList<String> emails = new ArrayList<>();
   private static final ArrayList<String> names = new ArrayList<>();

    public static void main(String[] args) {
        //Connect();        return super.isClosed();
        selectAll();
    }
    public publicKeysSQL() {
        Connect();
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
       /* finally {
            try {
                if (conn != null) {
                    conn.close();
                }

            } catch (SQLException ex) {
                ex.printStackTrace();
                System.out.println("Connection failed");
            }

        */

        return conn;
    }

    public static void insert(String email, String name, String SendRecieve, PublicKey pub) {
      String sql = "INSERT INTO PublicKeys(email, name, SendReceive, Keyvalue) VALUES(?,?,?,?)";
        try{
            Connection conn = Connect();

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2,name);
            pstmt.setString(3,SendRecieve);
            byte[] bytes = pub.getEncoded();
            pstmt.setBytes(4, bytes);
            pstmt.executeUpdate();
           // conn.commit();
            conn.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public static void selectAll(){
        String sql = "SELECT * FROM PublicKeys";

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

    public static void idArrayUpdater() {
        String sql = "SELECT * FROM PublicKeys";
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

   public static PublicKey getPublicKeyValue(StringBuilder email) throws NoSuchAlgorithmException, InvalidKeySpecException {
        // connecting to the database and retrieving data
        String sql = "SELECT Keyvalue FROM PublicKeys WHERE email LIKE '" + email + "%';";
       byte[] bytes = null;
       // try and catch loop
        try {
            Connection conn = Connect();
            Statement stm1 = conn.createStatement();
            ResultSet rs = stm1.executeQuery(sql);
            System.out.println(rs);
            // saving result set
            bytes = rs.getBytes("Keyvalue");
            conn.close();
        }
        catch (SQLException e) {
            System.out.println("SQL error");
            e.printStackTrace();
        }
        catch (Exception e) {
            System.out.println("General catch exception ran.");
            e.printStackTrace();
        }

        // setting up key for use
        X509EncodedKeySpec ks = new X509EncodedKeySpec(bytes);
        KeyFactory kf = KeyFactory.getInstance("RSA");
       return kf.generatePublic(ks);
    }




    // returning emails arraylist
    public static ArrayList<String> getEmails() {
        return (emails);
    }

    // returning names arraylist
    public static ArrayList<String> getNames() {
        return (names);
    }
}
