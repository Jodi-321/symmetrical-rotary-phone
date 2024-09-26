//
//  AddEntryView.swift
//  journalApp
//
//  Created by admin on 9/7/24.
//

import Foundation
import SwiftUI
import CoreData

struct AddEntryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isPresented: Bool
    
    @State private var content: String = ""
    @State private var moodRating: Int = 3 // This will be a example default mood rating
    
    // Resolve dependencies
    private let journalManager: JournalManagerProtocol
    
    init(isPresented: Binding<Bool>) {
        _isPresented = isPresented
        self.journalManager = DIContainer.shared.resolve(JournalManagerProtocol.self)!
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Journal Content")) {
                    TextEditor(text: $content)
                        .frame(height: 200)
                }
                
                Section(header: Text("Mood Rating")) {
                    Picker("Mood Rating", selection: $moodRating) {
                        ForEach(1...5, id: \.self) { rating in
                            Text("\(rating)").tag(rating)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Add New Entry")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                trailing: Button("Save") {
                    addEntry()
                }
            )
        }
    }


    private func addEntry() {
        journalManager.createEntry(content: content, moodRating: moodRating) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entry):
                    print("Entry added: \(entry)")
                    isPresented = false
                case .failure(let error):
                    print("Failed to add entry: \(error.localizedDescription)")
                }
            }
        }
    }
}

