package com.encryption.encryptionapplication;

import java.security.PrivateKey;
import java.security.PublicKey;
import java.sql.*;
import java.util.Arrays;

public class privateKeysSQL {
    private int ID;
    private String created;
    private String email;
    private String name;
    private char sendReceive;
    private String keysValue;


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

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public char getSendReceive() {
        return sendReceive;
    }

    public void setSendReceive(char sendReceive) {
        this.sendReceive = sendReceive;
    }

    public String getKeysValue() {
        return keysValue;
    }

    public void setKeysValue(String keysValue) {
        this.keysValue = keysValue;
    }
}
