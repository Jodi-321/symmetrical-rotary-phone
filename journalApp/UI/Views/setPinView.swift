//
//  This file is part of the JournalApp project.
//
//  Description: Core functionality for handling journal entries, encryption, and data persistence.
//  Version: 1.0
//  Last Updated: Oct. 6, 2024
//

import SwiftUI

struct SetPinView: View {
    @State private var newPin: String = ""
    @State private var confirmPin: String = ""
    @State private var errorMessage: String?
    
    private let authenticationManager: AuthenticationManagerProtocol
    
    init(authenticationManager: AuthenticationManagerProtocol) {
        self.authenticationManager = authenticationManager
    }
    
    var body: some View {
        VStack {
            SecureField("Enter new PIN", text:$newPin)
                .keyboardType(.numberPad)
                .padding()
                .border(Color.gray)
            SecureField("Confirm new PIN", text: $confirmPin)
                .keyboardType(.numberPad)
                .padding()
                .border(Color.gray)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button(action: setPin) {
                Text("Set PIN")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
        }
        .padding()
    }
    
    private func setPin() {
        guard newPin == confirmPin else {
            errorMessage = "PINs do not match"
            return
        }
        
        let success = authenticationManager.changePIN(newPin: newPin)
        if success {
            errorMessage = "PIN successfully set"
        } else {
            errorMessage = "Failed to set PIN"
        }
    }
}
