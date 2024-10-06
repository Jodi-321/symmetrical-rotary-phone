# JournalApp: Security Features Overview

**JournalApp** is designed with a strong emphasis on security and privacy, ensuring that all user data is protected with industry-standard practices. This document outlines the core security implementations, showcasing how the app ensures that user information, particularly journal entries, is safeguarded from unauthorized access. The app uses robust encryption, secure key management, and PIN-based authentication, with additional security measures for PIN recovery through security questions.

---

## Key Security Features

### AES-256 Encryption
**All journal entries are encrypted using the AES-256 algorithm**, one of the strongest encryption standards in the industry. This ensures that your data remains confidential even if the device is compromised.

- **Code Example (Encryption)**:
  ```swift
  let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
  let encryptedBytes = try aes.encrypt(data.bytes)
  ```

- **Code Example (Decryption)**:
  ```swift
  let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7)
  let decryptedData = try aes.decrypt(encryptedBytes)
  ```

- **Output Example**:
  ```
  Generated encryption key: 5e199b80e9beeed9000f4dd39397fa1827be81d9faa08e559bb0cded92f523d2
  [DEBUG] Decrypting journal entry...
  ```

### Secure Key Management
**Encryption keys are securely stored using the iOS Keychain**, a highly secure storage solution for sensitive information. This ensures that the encryption keys remain inaccessible to unauthorized users or attackers, even in case of a breach.

- **Code Example**:
  ```swift
  func storeKey(_ key: Data, forKey keyName: String) throws {
      let query: [String: Any] = [
          kSecClass as String: kSecClassGenericPassword,
          kSecAttrAccount as String: keyName,
          kSecValueData as String: key,
          kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
      ]
      SecItemDelete(query as CFDictionary)
      let status = SecItemAdd(query as CFDictionary, nil)
  }
  ```

- **Output Example**:
  ```
  [DEBUG] Retrieved encryption key from Keychain.
  ```

### PIN-Based Authentication
The app uses **PIN-based authentication** to restrict access to its contents. The user's PIN is securely hashed and stored using the Keychain, ensuring that it is not stored in plain text and remains protected even in case of device compromise.

- **Code Example (PIN Hashing)**:
  ```swift
  private func hashPIN(_ pin: String, withSalt salt: Data) -> Data {
      var hasher = SHA256()
      hasher.update(data: salt)
      hasher.update(data: Data(pin.utf8))
      return Data(hasher.finalize())
  }
  ```

- **Output Example**:
  ```
  [DEBUG] Hashed PIN: bZM0SxBfuYgIr6unO/Gw1JY6zBagn2nrC6t9FbEeKxs=
  [DEBUG] PIN is stored.
  ```

### Security Questions for PIN Recovery
In case a user forgets their PIN, **security questions** can be set to allow secure PIN recovery. The user's answers to these questions are hashed and stored securely, ensuring they are never stored in plain text.

- **Code Example (Security Questions)**:
  ```swift
  func setSecurityQuestions(_ questions: [SecurityQuestion]) -> Bool {
      try keychainManager.storeSecurityQuestions(questions, forKey: "userSecurityQuestions")
  }
  
  private func hashAnswer(_ answer: String) -> String {
      let hashedData = SHA256.hash(data: Data(answer.utf8))
      return Data(hashedData).base64EncodedString()
  }
  ```

- **Output Example**:
  ```
  [DEBUG] Security questions set successfully.
  ```

### Data Confidentiality and Integrity
With encryption in place, **all journal data remains confidential** at rest and during any data operations within the app. The app ensures that no plaintext journal entries are ever written to disk or stored unprotected in memory.

- **Output Example**:
  ```
  [DEBUG] Encrypting journal entry before saving to Core Data.
  ```

---

## How Architecture Enhances Security

JournalApp's **modular architecture** plays a significant role in improving security by separating concerns and isolating critical components:

### 1. **SecurityManager**
Handles encryption, decryption, and secure data transmission. It ensures that all encryption keys are managed separately and that no unencrypted data leaves the module.

### 2. **KeychainManager**
Handles the secure storage and retrieval of sensitive data such as encryption keys and PINs. By delegating key management to a separate component, the app reduces potential vulnerabilities.

### 3. **AuthenticationManager**
Responsible for managing user authentication and ensuring that sensitive data is only accessible after successful PIN verification. It securely handles PIN validation and recovery operations.

- **Code Example (Authentication Flow)**:
  ```swift
  func authenticateUser(pin: String) -> Bool {
      let (salt, storedHashedPIN) = try keychainManager.retrieveHashedPIN(forKey: "userPIN")
      let enteredHashedPIN = hashPIN(pin, withSalt: salt)
      return enteredHashedPIN == storedHashedPIN
  }
  ```

---

## Debugging and Development Considerations

JournalApp is in its **MVP (Minimum Viable Product)** stage, with several security-related functionalities still under development. The app currently includes **console-printed debugging information** to demonstrate encryption and decryption processes, as well as authentication logic. 

**This app is not intended for production use** in its current form due to the presence of development and debugging outputs. The debugging outputs are intentionally included to provide insights into the encryption and key management processes for potential customers or employers evaluating the security aspects of the app.

---

## Work in Progress

Some features related to data migration, error handling, and advanced security functionalities are still under development. These components will enhance the overall robustness of the app but are not yet ready for deployment in a production environment.

---

**JournalApp** showcases cutting-edge security practices while providing a secure and user-friendly personal journaling experience. The security-first approach implemented throughout this app ensures that your journal entries remain private and protected at all times.

--- 

For more information, visit the [main README](#) for a general overview of the app and its core features.


--- 

