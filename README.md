# JournalApp

## Overview

**JournalApp** is a secure, personal journaling application designed to allow users to create, store, and manage journal entries with an emphasis on data privacy and encryption. Currently in its Minimum Viable Product (MVP) stage, this project showcases the integration of advanced security measures and modular architecture to protect users' sensitive data. It demonstrates best practices in app development, security-first principles, and clean architecture, serving as a portfolio piece for potential employers or customers.

**Important:** This application is intended for demonstration purposes only and is not ready for production use. Some features are still in progress, and debugging information is printed to the console to showcase key functionality, including encryption and decryption.

## Project Goals

JournalApp is developed with the following core objectives in mind:

- **Security First**: Robust encryption mechanisms ensure that all user data, including journal entries, are securely encrypted at rest and in transit.
- **User-Friendly Interface**: A simple and intuitive interface allows users to create, edit, and manage journal entries with ease.
- **Modular Architecture**: The app is structured using a modular approach, making it scalable, maintainable, and easy to extend in future updates.
- **MVP Focus**: Core journaling functionalities are the current focus, including user authentication, encrypted storage of entries, and a seamless journaling experience.

## Key Features

### 1. Security-First Approach
- **AES-256 Encryption**: All journal entries are encrypted using the AES-256 algorithm, one of the strongest encryption standards in the industry, ensuring data confidentiality.
- **Secure Key Management**: Encryption keys are securely stored using the iOS Keychain, preventing unauthorized access even in the case of device compromise.
- **PIN-Based Authentication**: Access to the app's content is restricted by a secure PIN, which is hashed and stored safely using the iOS Keychain.
- **Security Questions**: Users can set security questions to recover their PIN in case they forget it, further enhancing data protection.

### 2. Modular Architecture
JournalApp uses a **Model-View-ViewModel (MVVM)** and **Model-View-Controller (MVC)** hybrid architecture. This modular approach ensures that each feature of the app is self-contained, enabling easy scalability and maintainability.

- **Core Data Stack**: A singleton CoreDataStack manages all local data persistence operations. This ensures a single source of truth for data storage, while also supporting future scalability.
- **Security Module**: Handles encryption, decryption, and key management using industry-standard security protocols.
- **Journal Module**: Manages the creation, reading, updating, and deletion of journal entries while ensuring that all sensitive data is securely encrypted before being stored.
- **Authentication Module**: Provides PIN-based user authentication and secure access control to the app.
- **UI Module**: Manages all SwiftUI components, ensuring a clean and intuitive user interface.

### 3. Console Debugging for Showcase Purposes
To demonstrate key functionalities, particularly the encryption and decryption processes, the app currently prints debugging information to the console. This includes logging encrypted data, decrypted content, and other key operations to illustrate the app's security capabilities. **These logs are present for educational and showcase purposes and should not be included in a production environment.**

### 4. Work In Progress (WIP) Modules
Several features are still under active development, including enhanced mood tracking, advanced analytics, and seamless data backups. These modules are in progress, and as such, the application is not intended for production use at this time.

## Project Status

This project is currently in its MVP stage. Key functionalities like secure journaling and user authentication are implemented, but there are some incomplete areas, including:

- **Mood Tracking**: Functionality is planned but not fully implemented.
- **Backup & Restore**: Basic backup functionality exists, but restore functionality is not fully operational yet.
- **Analytics**: Advanced journaling analytics will be added in future iterations.

## Why JournalApp Was Created

JournalApp was developed as part of a showcase portfolio to demonstrate my technical skills and abilities to potential employers and customers. The focus on secure coding practices, modular design, and advanced data encryption mechanisms highlights my commitment to producing high-quality, secure software solutions. This project is an example of how I approach software development with both user experience and security as priorities.

## How to Use This Project

As this project is for demonstration purposes only, users can explore the application to understand its architecture and functionality. However, it is not recommended for use in a production environment due to the presence of debugging information and ongoing development in certain modules.

### Setup

To get started with the project:
1. Clone the repository.
2. Open the project in Xcode.
3. Run the app on a simulator or device to explore its features, with special attention to the security implementations.

**Note:** This project requires iOS 13.0 or higher.

## Conclusion

JournalApp represents a secure, modular, and user-friendly journaling solution. While still in its MVP phase, it showcases my skills in building secure, maintainable applications. As the project evolves, more features will be added, but for now, it serves as a strong foundation for future development and a demonstration of my technical abilities.
