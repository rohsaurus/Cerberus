package com.encryption.encryptionapplication;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TabPane;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.stage.Stage;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;


public class KeyManagerSceneController implements Initializable {

    @FXML
    private Button DecryptButton;

    @FXML
    private Button EncryptButton;

    @FXML
    private Button KeyPair;

    @FXML
    private TabPane keyList;

    @FXML
    private Button keyManager;

    @FXML
    private TableColumn<?, ?> privateCreated;

    @FXML
    private TableColumn<?, ?> privateEmail;

    @FXML
    private TableColumn<?, ?> privateID;

    @FXML
    private TableColumn<?, ?> privateKeyValue;

    @FXML
    private TableColumn<?, ?> privateName;

    @FXML
    private TableView<?> privateTable;

    @FXML
    private TableColumn<?, ?> publicCreated;

    @FXML
    private TableColumn<?, ?> publicEmail;

    @FXML
    private TableColumn<?, ?> publicID;

    @FXML
    private TableColumn<?, ?> publicKeyValue;

    @FXML
    private TableColumn<?, ?> publicName;

    @FXML
    private TableColumn<?, ?> publicSend;

    @FXML
    private TableView<?> publicTable;

    @FXML
    private Parent root;

    @FXML
    private Stage stage;

    @FXML
    private Scene scene;

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {

    }
    public void keyManager(ActionEvent event) throws IOException {
        Parent root = FXMLLoader.load(getClass().getResource("SceneOne.fxml"));
        stage = (Stage)((Node)event.getSource()).getScene().getWindow();
        scene = new Scene(root);
        stage.setScene(scene);
        stage.show();
    }


}
