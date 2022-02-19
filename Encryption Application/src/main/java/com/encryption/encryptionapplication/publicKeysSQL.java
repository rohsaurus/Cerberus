package com.encryption.encryptionapplication;

import java.security.PublicKey;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;

public class publicKeysSQL {
    private int ID;
    private String created;
    private String email;
    private String name;
    private char sendReceive;
    private String keysValue;
   private static ArrayList<String> emails = new ArrayList<>();
   private static ArrayList<String> names = new ArrayList<>();

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
            String url = "jdbc:sqlite:/home/rohan/IdeaProjects/Encryption Application/Encryption Application/src/DB/cerberus.sqlite";
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

    public static void keyValue() throws SQLException {
        String sql = "SELECT * FROM PublicKeys";

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

    public static ArrayList<String> getEmails() {
        return (emails);
    }

    public static ArrayList<String> getNames() {
        return (names);
    }
}
