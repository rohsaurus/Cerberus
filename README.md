<h1 align="center">Welcome to Cerberus 👋</h1>

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->
</a>
  <a href="https://github.com/rohsaurus/Cerberus/blob/Main/License" target="_blank">
    <img alt="License: BSD--3" src="https://img.shields.io/badge/License-BSD--3-yellow.svg" />
  </a>

> The Cerberus Releases no longer work as I am no longer running the database to store encrypted keys and user credientials. The program still works, you just need to compile it and run your own MongoDB instance. See contributing.md for details

Cerberus uses XChaCha20 and RSA to allow you to encrypt any file and send it across the web securly, without the need to share a password! No longer do you need to text the password to the recipient, or send an email with an attached RSA key. Instead, simply fire up Cerberus and type in the email of the recipient. Then send the encrypted file to the recipient, where all your friend needs to do is simply open up the file with Cerberus! No need to enter in a password, or import some RSA key!

### Table Of Contents

- [Install](#install)
- [Usage](#usage)
  - [Must do this for both Sender and Reciever first!](#must-do-this-for-both-sender-and-reciever-first)
  - [Sender:](#sender)
  - [Reciever:](#reciever)
- [Author](#author)
- [🤝 Contributing](#-contributing)
- [Show your support](#show-your-support)
- [Contributors](#contributors)
- [📝 License](#-license)

### 🏠 [Homepage](https://github.com/rohsaurus/Cerberus)

### ✨ [Demo](Not Avaliable right now)

## Install

Simply head to releases(https://github.com/rohsaurus/Cerberus/releases) and download and extract the zip for your OS.

## Usage

Once you extract the zip file, run the binary file inside of it. On Linux, you might need to enable read, write, and execute prvillages on the binary. Open up the terminal, and naviagate where you extracted the zip. Run ``sudo chmod 777 ./cerberus``. On Windows, once you extract it, Windows may inform you that the app is from an unknown publisher or that Microsoft Defender blocked the running of the application. That is because I haven't purchased a digital certificate for the application. Simply click the continue button, or if that's not there, more information and then continue.

### Must do this for both Sender and Reciever first!

Both Sender and Reciever must create an account first.

If this is your first time, you must create an account. The app will default open to the login screen, but there is a button that will take you straight to the sign up page.

![image](https://user-images.githubusercontent.com/55811427/221426028-119f71d6-1c42-4d8f-a8ec-3c5c540bc26c.png)

Fill out your details.
![image](https://user-images.githubusercontent.com/55811427/221426056-6113f9e5-8b64-49de-ab9d-ca88c1141022.png)

### Sender:

Once you reach this screen, simply click encrypt, and type the email of the recipient. Note, this email must be the same that the recipient used to open Cerberus.
![image](https://user-images.githubusercontent.com/55811427/221426470-3dbbc9d4-cf7a-414b-ac9d-e0d78f783bc2.png)
![image](https://user-images.githubusercontent.com/55811427/221426504-dc282f9b-53af-4cae-b281-4f925fa53a1e.png)

After encryption is complete, you will get a message like this on the bottom. By default, Cerberus will always save the encrypted copy next to the original copy.
![image](https://user-images.githubusercontent.com/55811427/221426579-0fe5b4b0-0cdc-40af-a843-3e1dfe21f81f.png)
Now, you must send the file to the reciever.

### Reciever:

Once you login, click decrypt.
You'll get a prompt like this.
![image](https://user-images.githubusercontent.com/55811427/221426692-4d60843f-0e3e-498d-8d81-a3283125b04f.png)
Click decrypt and choose the encrypted file. It will have a file extension of .cerb at the end.
![image](https://user-images.githubusercontent.com/55811427/221426732-d2c0ab8d-104a-4097-a75e-c18a209c2305.png)

> I run Linux, so my file picker looks like this, but the program will use whatever file picker your operating system uses.

And like, the file is decrypted, and ready for the reciever to use!
![image](https://user-images.githubusercontent.com/55811427/221426780-c5e8cab9-98c5-4e45-ba0c-9501ad24dd78.png)

> In the usage guide, I used two seperate accounts to simulate two different machines. It works the same way as if you were to have two seperate machines.

## Author

👤 **Rohan Parikh**

* Website: https://github.com/rohsaurus
* Github: [@rohsaurus](https://github.com/rohsaurus)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!`<br />`Feel free to check [issues page](https://github.com/rohsaurus/Cerberus/issues). You can also take a look at the [contributing guide](https://github.com/rohsaurus/Cerberus/blob/Main/contributing.md).

## Show your support

Give a ⭐️ if this project helped you!
And feel free to

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->

<!-- prettier-ignore-start -->

<!-- markdownlint-disable -->

<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/JacobyBlanke"><img src="https://avatars.githubusercontent.com/u/40186603?v=4?s=100" width="100px;" alt="Jacoby"/><br /><sub><b>Jacoby</b></sub></a><br /><a href="#platform-JacobyBlanke" title="Packaging/porting to new platform">📦</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->

<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

<!-- prettier-ignore-start -->

<!-- markdownlint-disable -->

<!-- markdownlint-restore -->

<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

## 📝 License

Copyright © 2023 [Rohan Parikh](https://github.com/rohsaurus).`<br />`
This project is [BSD-3](https://github.com/rohsaurus/Cerberus/blob/Main/License) licensed.

- [Install](#install)
- [Usage](#usage)
  - [Must do this for both Sender and Reciever first!](#must-do-this-for-both-sender-and-reciever-first)
  - [Sender:](#sender)
  - [Reciever:](#reciever)
- [Author](#author)
- [🤝 Contributing](#-contributing)
- [Show your support](#show-your-support)
- [Contributors](#contributors)
- [📝 License](#-license)

---

_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_
