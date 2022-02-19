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
import javafx.stage.Stage;
import javafx.util.Pair;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicReference;
import javafx.event.ActionEvent;

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

    public void generateKeyPair() {
        // setting up the layout of the dialog box
        Dialog<Pair<String,String>> dialog = new Dialog<>();
        dialog.setTitle("Key Information");
        dialog.setHeaderText("Enter in the email and name");
        ButtonType dataCollection = new ButtonType("OK", ButtonBar.ButtonData.OK_DONE);
        dialog.getDialogPane().getButtonTypes().addAll(dataCollection,ButtonType.CANCEL);
        // Creating grid to collect name and email
        GridPane grid = new GridPane();
        grid.setHgap(10.0);
        grid.setVgap(10.0);
        grid.setPadding(new Insets(20,150,10,10));
        // creating fields to actually collect the data
        TextField email = new TextField();
        email.setPromptText("Enter Email");
        TextField name = new TextField();
        name.setPromptText("Enter name");
        // adding fields to the grid
        grid.add(new Label("Email:"),0,0);
        grid.add(email,1,0);
        grid.add(new Label("Name:"),0,1);
        grid.add(name,1,1);
        // Preventing user from submitting prompt without adding email
        Node submitButton = dialog.getDialogPane().lookupButton(dataCollection);
        email.textProperty().addListener((observable,oldValue,newValue) -> {
            submitButton.setDisable(newValue.trim().isEmpty());
        });

        dialog.getDialogPane().setContent(grid);

        // request focus on the name field by default
        Platform.runLater(() -> email.requestFocus());

        // Converting name and email fields intoa pair
        dialog.setResultConverter(dialogButton -> {
            if (dialogButton == dataCollection) {
                return  new Pair<>(email.getText(),name.getText());
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
            }
            else {
               //
                //fileName.set(String.valueOf(timeAndDate));
                fileName.set(emailName.getKey());
                emailValue.set(emailName.getKey());
            }
        });

        try {
            RSA.generateKeyPair(fileName.get());
        } catch (NoSuchAlgorithmException | IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println(e);
        }
        PublicKey temp = RSA.getPub();
        PrivateKey privateOne = RSA.getPvt();
        String emailNew = String.valueOf(emailValue);
        String nameNew = String.valueOf(nameValue);
        publicKeysSQL.insert(emailNew, nameNew, "Send", temp);
        privateKeysSQL.insert(emailNew,nameNew,"Receive",privateOne);
    }

    public void keyManager(ActionEvent event) throws IOException {
        Parent root = FXMLLoader.load(getClass().getResource("keyManagerScene.fxml"));
        stage = (Stage)((Node)event.getSource()).getScene().getWindow();
        scene = new Scene(root);
        stage.setScene(scene);
        stage.show();
    }

    public void encrypt() throws SQLException {
        // Showing user which key they can select to use for encryption
        publicKeysSQL.keyValue();
        List<String> choices = new ArrayList<>();
        List<String> emails = publicKeysSQL.getEmails();
        List<String> names = publicKeysSQL.getNames();
        for (int i = 0; i < emails.size()-1; i ++) {
            choices.add(emails.get(i) + " - " + names.get(i));
        }
        // setting up dialog box
        ChoiceDialog<String> dialog = new ChoiceDialog<>((emails.get(0) + " - " + names.get(0)), choices);
        dialog.setTitle("Choose Which Key");
        dialog.setHeaderText("Pick From the Choices Below");
        dialog.setContentText("Choose Your Key");
        Optional<String> result = dialog.showAndWait();
        result.ifPresent(letter -> System.out.println("Your choice: " + letter));

    }
}