![cloudy_gh](https://github.com/user-attachments/assets/f83bb039-fea3-4161-bd4c-4e29106d9493)
![Dart Version](https://img.shields.io/badge/dart-%3E%3D2.12-brightgreen) ![Flutter](https://img.shields.io/badge/Made%20with-Flutter-blue)
![Open Source](https://img.shields.io/badge/Open%20Source-Yes-brightgreen) ![Crypto](https://img.shields.io/badge/ETP%20Protocol-Custom-orange) ![Flutter Version](https://img.shields.io/badge/flutter-v3.23.0-blue) ![License](https://img.shields.io/badge/license-GPLv2-orange) ![Platform](https://img.shields.io/badge/platform-Android%20|%20iOS%20-blue) ![GitHub Stars](https://img.shields.io/github/stars/kmdshi/cloudy?style=social) ![Last Commit](https://img.shields.io/github/last-commit/kmdshi/cloudy)
# Cloudy

## Description
**Cloudy** is a secure messaging application built on a custom protocol known as ETP (Encrypted Transfer Protocol). The primary goal of Cloudy is to ensure the confidentiality and security of user communications. With a user-friendly interface, Cloudy allows users to exchange messages while keeping their data safe from unauthorized access. The application emphasizes strong encryption and privacy measures, providing peace of mind for users who value their privacy. Future enhancements will focus on additional features that further strengthen user security and streamline communication.

## Features

- **Registration**:
  Users can create an account through a secure registration process, which includes email verification to ensure the authenticity of the user before accessing the application.

- **Encryption**:
  All communications within the app are secured using robust encryption methods. This ensures that user messages remain confidential and protected from unauthorized access.

- **Messaging**:
  Users can engage in real-time conversations with friends, sharing messages, images, and files securely. The messaging feature is designed for ease of use, providing an intuitive chat interface.

- **Friend Addition**:
  Users can add friends to their contacts easily, allowing for seamless communication.

### Mini-Features
- **QR Code Friend Addition**:
  Users have the option to add friends by scanning QR codes, providing a quick and efficient way to connect. This feature is still in development. Additionally, users can invite others through deep links to the application.

- **Multi-Device Support**:
  Users can log into their accounts from different devices without losing their chat history or ongoing conversations, ensuring continuity and flexibility in communication.

- **User Reporting**:
  While we prioritize user confidentiality and privacy, we encourage responsible use of the platform. Users can report malicious or inappropriate behavior. We maintain a zero-tolerance policy for illegal activities, and any such conduct will be     addressed in accordance with applicable laws and regulations.

## Encrypt

The encryption system utilizes advanced technologies and algorithms to ensure secure data transmission. The following steps outline the encryption process implemented in the `CipherService` class, referred to as **ETP (Edge Transport Protocol)**.

### ETP (Edge Transport Protocol) Encryption Algorithm

1. **Key Generation:**
   - A unique key pair (public and private keys) is generated using the RSA algorithm, based on a seed created from the user's nickname and key phrases. This seed enhances security by providing randomness specific to the user.
   - The `createKeyPair` method initializes the RSA key generator and generates a key pair.

2. **Symmetric Key Generation:**
   - A random AES key is generated for symmetric encryption using a secure random number generator.
   - The `generateRandomAESKey` method creates a 32-byte key, which is then encoded in Base64 for easy transmission.

3. **Encryption of the Symmetric Key:**
   - The generated AES key is encrypted using the recipient's public RSA key, ensuring that only the intended recipient can decrypt it using their private key.
   - The `encryptSymmetricKey` method handles this encryption process.

4. **Message Encryption:**
   - The plain text message is encrypted using the AES algorithm with the previously generated symmetric key.
   - An initialization vector (IV) is used to enhance the security of the AES encryption.
   - The `encryptMessage` method encrypts the plain text, and the encrypted result is returned in Base64 format for transmission.

5. **Decryption Process:**
   - Upon receiving the encrypted symmetric key, the recipient uses their RSA private key to decrypt the symmetric key using the `decryptSymmetricKey` method.
   - The recipient then uses the decrypted symmetric key to decrypt the message using the `decryptMessage` method.

6. **Integrity and Security:**
   - The algorithm employs SHA-256 hashing to create unique identifiers and secure seeds, ensuring data integrity and confidentiality throughout the encryption process.

This robust encryption framework ensures that sensitive data remains secure during transmission, leveraging state-of-the-art cryptographic techniques.

![registration-gh-scheme](https://github.com/user-attachments/assets/5d890a47-fcea-4b52-a863-6efb288f4df3)

The diagram above illustrates the registration process for users. Below it, you can see the dialog initiation scheme, which outlines how users establish secure communication.
![dialog-gh-scheme](https://github.com/user-attachments/assets/58e33cf3-73c5-4491-b0ac-cbd6448fc68b)


## **Tech Stack**

### **Frontend:**
- Flutter: `^3.4.0` (SDK)
- Google Fonts: `^6.2.1`
- Cupertino Icons: `^1.0.8`
- Lottie: `^3.1.2`
- Image Picker: `^1.1.2`
- QR Code Scanner: `^1.0.1`
- QR Flutter: `^4.1.0`
- Tab Indicator Styler: `^2.0.0`

### **Backend:**
- Firebase Core: `^3.4.0`
- Cloud Firestore: `^5.3.0`
- Firebase Storage: `^12.2.0`
- App Links: `^6.3.1`
- Flutter Secure Storage: `^9.2.2`
  
### **Database:**
- Cloud Firestore (as a NoSQL database)

### **Security:**
- Encrypt: `^5.0.3`
- Crypto: `^3.0.5`
- Flutter Secure Storage: `^9.2.2`

### **Utilities:**
- Basic Utils: `^5.7.0`
- Collection: `^1.18.0`
- Intl: `^0.19.0`
- Pointy Castle: `^3.9.1`
- Get It: `^7.7.0`
- Injectable: `^2.4.4`
- Flutter Bloc: `^8.1.6`
- Go Router: `^14.2.7`
- Shared Preferences: `^2.3.2`
- Mobkit Dashed Border: `^0.0.6`

### **Testing:**
- Flutter Test: `sdk: flutter`
- Build Runner: `^2.4.12`
- Flutter Gen: `^5.7.0`
  
### **Code Quality:**
- Flutter Lints: `^4.0.0`
- Injectable Generator: `^2.6.1`

## DEMO

https://github.com/user-attachments/assets/0da2043d-6681-42ef-8a46-446035725da7

## Deployment

### Local Deployment

1. Clone the repository:
  ```
  git clone https://github.com/kmdshi/cloudy.git
  ```
  2. Navigate to the project directory:
  ```
  cd cloudy
  ```
  3.Install the required dependencies:
  ```
  flutter pub get
  ```
  4. Set up the environment variables:
  ```
  configure firebase to your project
  ```  
5. Run the application on your device or emulator:
  ```
  flutter run
  ```
## Design

The design of this application was inspired by open-source resources available on Figma. We utilized various templates and components to create a modern and user-friendly interface. All design elements were adapted to meet the needs of our project, ensuring a cohesive user experience while respecting the original sources.

## License

This project is licensed under the GPL v2 License. See the `LICENSE` file for more information.

## Contact Information

For any questions, issues, or suggestions, please reach out to the project maintainer:

- **GitHub:** [kmdshi](https://github.com/kmdshi)
- **telegram** - [Contact me](https://t.me/kmdshi)<br />
- **Project Link** : [Share project link](https://github.com/kmdshi/cloudy)

