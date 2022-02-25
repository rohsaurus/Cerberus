package com.encryption.encryptionapplication;

import javafx.application.Platform;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.geometry.Insets;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.GridPane;
import javafx.stage.FileChooser;
import javafx.stage.Stage;
import javafx.util.Pair;

import java.io.*;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicReference;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javafx.event.ActionEvent;

import javax.crypto.*;
import javax.crypto.spec.IvParameterSpec;

public class SceneOneController {
    @FXML
    private Button KeyPair;

    @FXML
    private Button EncryptButton;

    @FXML
    private Button DecryptButton;

    @FXML
    private Button keyManager;

    private Stage stage;

    private Scene scene;

    private Parent root;

    private final String AESalgorithm = "AES/CBC/PKCS5Padding";
    private final String RSAalgorithm = "RSA/ECB/PKCS1Padding";

    public void generateKeyPair() {
        // setting up the layout of the dialog box
        Dialog<Pair<String, String>> dialog = new Dialog<>();
        dialog.setTitle("Key Information");
        dialog.setHeaderText("Enter in the email and name");
        ButtonType dataCollection = new ButtonType("OK", ButtonBar.ButtonData.OK_DONE);
        dialog.getDialogPane().getButtonTypes().addAll(dataCollection, ButtonType.CANCEL);
        // Creating grid to collect name and email
        GridPane grid = new GridPane();
        grid.setHgap(10.0);
        grid.setVgap(10.0);
        grid.setPadding(new Insets(20, 150, 10, 10));
        // creating fields to actually collect the data
        TextField email = new TextField();
        email.setPromptText("Enter Email");
        TextField name = new TextField();
        name.setPromptText("Enter name");
        // adding fields to the grid
        grid.add(new Label("Email:"), 0, 0);
        grid.add(email, 1, 0);
        grid.add(new Label("Name:"), 0, 1);
        grid.add(name, 1, 1);
        // Preventing user from submitting prompt without adding email
        Node submitButton = dialog.getDialogPane().lookupButton(dataCollection);
        email.textProperty().addListener((observable, oldValue, newValue) -> submitButton.setDisable(newValue.trim().isEmpty()));

        dialog.getDialogPane().setContent(grid);

        // request focus on the name field by default
        Platform.runLater(email::requestFocus);

        // Converting name and email fields intoa pair
        dialog.setResultConverter(dialogButton -> {
            if (dialogButton == dataCollection) {
                return new Pair<>(email.getText(), name.getText());
            }
            return null;
        });

        Optional<Pair<String, String>> result = dialog.showAndWait();


        AtomicReference<String> fileName = new AtomicReference<>("");
        AtomicReference<String> nameValue = new AtomicReference<>("");
        AtomicReference<String> emailValue = new AtomicReference<>("");
        result.ifPresent(emailName -> {
            if (emailName.getValue().length() >= 1) {
                fileName.set(emailName.getValue());
                nameValue.set(emailName.getValue());
                emailValue.set(emailName.getKey());
            } else {
                //
                //fileName.set(String.valueOf(timeAndDate));
                fileName.set(emailName.getKey());
                emailValue.set(emailName.getKey());
            }
        });

        try {
            RSA.generateKeyPair(fileName.get());
        } catch (NoSuchAlgorithmException | IOException e) {
            System.out.println("IO Exception or no such algorithm exception");
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        PublicKey temp = RSA.getPub();
        PrivateKey privateOne = RSA.getPvt();
        String emailNew = String.valueOf(emailValue);
        String nameNew = String.valueOf(nameValue);
        publicKeysSQL.insert(emailNew, nameNew, "Send", temp);
        privateKeysSQL.insert(emailNew, nameNew, "Receive", privateOne);
    }

    public void keyManager(ActionEvent event) throws IOException {
        Parent root = FXMLLoader.load(getClass().getResource("keyManagerScene.fxml"));
        stage = (Stage) ((Node) event.getSource()).getScene().getWindow();
        scene = new Scene(root);
        stage.setScene(scene);
        stage.show();
    }

    public void encrypt() throws NoSuchAlgorithmException, InvalidKeySpecException, InvalidKeyException, IOException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException {
        // Showing user which key they can select to use for encryption
        publicKeysSQL.idArrayUpdater();
        List<String> choices = new ArrayList<>();
        List<String> emails = publicKeysSQL.getEmails();
        List<String> names = publicKeysSQL.getNames();
        for (int i = 0; i < emails.size() - 1; i++) {
            choices.add(emails.get(i) + " - " + names.get(i));
        }
        // setting up dialog box
        ChoiceDialog<String> dialog = new ChoiceDialog<>((emails.get(0) + " - " + names.get(0)), choices);
        dialog.setTitle("Choose Which Key");
        dialog.setHeaderText("Pick From the Choices Below");
        dialog.setContentText("Choose Your Key");
        Optional<String> result = dialog.showAndWait();
        // getting the choice user made to send request to sql database to use that for encryption
        String keyID = "";
        if (result.isPresent()) {
            keyID = result.get();
        }

        // formatting keyID into email
        Matcher m = Pattern.compile("[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+").matcher(keyID);
        StringBuilder emailAddressStringBuilder = new StringBuilder();
        while (m.find()) {
            emailAddressStringBuilder.append(m.group());
        }
        if (!emailAddressStringBuilder.isEmpty()) {
            // retrieving public key to use in encryption
            PublicKey pub = publicKeysSQL.getPublicKeyValue(emailAddressStringBuilder);

            // prompting the user to choose a file for encryption
            FileChooser fileChooser = new FileChooser();
            File selectedFile = fileChooser.showOpenDialog(stage);

            // generating AES encryption key
            IvParameterSpec iv = AES.generateIv();
            SecretKey sec = AES.generateKey();

            // encrypting file via AES

            // Encrypting file via AES and encrypting the AES key
            FileOutputStream output = new FileOutputStream(selectedFile + ".cerb");
            Cipher cipherPub = Cipher.getInstance(RSAalgorithm);
            cipherPub.init(Cipher.ENCRYPT_MODE, pub);
            byte[] b = cipherPub.doFinal(sec.getEncoded());
            System.out.println(b.length);
            output.write(b);

            // writing IV to file as well
            output.write(iv.getIV());

            Cipher ci = Cipher.getInstance(AESalgorithm);
            ci.init(Cipher.ENCRYPT_MODE, sec, iv);
            // writing to file
            try (FileInputStream in = new FileInputStream(selectedFile)) {
                processFile(ci, in, output);
            }
        }
    }


    // processing file to encrypt/decrypt
    private void processFile(Cipher ci, FileInputStream in, FileOutputStream output) throws  IllegalBlockSizeException, BadPaddingException, java.io.IOException{
        byte[] ibuf = new byte[1024];
        int len;
        while ((len = in.read(ibuf)) != -1) {
            byte[] obuf = ci.update(ibuf, 0, len);
            if ( obuf != null ) output.write(obuf);
        }
        byte[] obuf = ci.doFinal();
        if ( obuf != null ) output.write(obuf);
    }

}
