# Dependencies

This document lists all the external libraries and frameworks used in the Journal Entry App, along with their purposes, installation methods, and any specific configurations required.

## 1. Core Data

- **Purpose**: Local data persistence.
- **Installation**: Built-in iOS framework.
- **Configuration**: No additional setup required. Core Data is integrated directly within the Xcode project. Set up the Core Data Stack in the project using `NSPersistentContainer`.

## 2. Combine

- **Purpose**: Reactive programming and managing asynchronous data flows.
- **Installation**: Built-in iOS framework.
- **Configuration**: No additional setup required. Import `Combine` where needed and use `Publishers`, `Subscribers`, and `Cancellables` for managing data flow.

## 3. CryptoSwift

- **Purpose**: Encryption and decryption.
- **Installation**: Swift Package Manager.
  - **Steps**:
    1. Open your project in Xcode.
    2. Go to **File > Swift Packages > Add Package Dependency**.
    3. Enter the URL: `https://github.com/krzyzanowskim/CryptoSwift`.
    4. Choose the version rule and click **Next**.
    5. Select the appropriate target and click **Finish**.
- **Configuration**: Import `CryptoSwift` in the files where you need encryption and decryption functionalities.

## 4. Swinject

- **Purpose**: Dependency injection.
- **Installation**: Swift Package Manager.
  - **Steps**:
    1. Open your project in Xcode.
    2. Go to **File > Swift Packages > Add Package Dependency**.
    3. Enter the URL: `https://github.com/Swinject/Swinject`.
    4. Choose the version rule and click **Next**.
    5. Select the appropriate target and click **Finish**.
- **Configuration**: Register all services in the `DIContainer.swift` file to manage dependency injection throughout the app.

## 5. Charts

- **Purpose**: Data visualization.
- **Installation**: Swift Package Manager.
  - **Steps**:
    1. Open your project in Xcode.
    2. Go to **File > Swift Packages > Add Package Dependency**.
    3. Enter the URL: `https://github.com/danielgindi/Charts`.
    4. Choose the version rule and click **Next**.
    5. Select the appropriate target and click **Finish**.
- **Configuration**: Import `Charts` in the files where you need to use charts. Refer to the official documentation for custom chart setups.

## 6. Other Libraries

- If there are any other libraries used in the project, add them here following the same format.

## Notes

- **Swift Package Manager** is the preferred method for managing dependencies in this project. It allows for easy updates and compatibility management.
- Always keep your libraries updated to the latest stable versions to avoid security vulnerabilities and to leverage new features and improvements.
