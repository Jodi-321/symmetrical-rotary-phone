//
//  ContentView.swift
//  journalApp
//
//  Created by admin on 9/7/24.
//

import Foundation
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    // Init the FetchedResultsControllerDelegate
    @StateObject private var fetchedResultsControllerDelegate: FetchedResultsControllerDelegate
    
    // Instantiate SecurityManager
    private let securityManager: SecurityManagerProtocol
    
    init() {
        // Create the NSFetchedResultsController using the repository
        let repository = CoreDataJournalRepository()
        let fetchedResultsController = repository.createFetchedResultsController()
        _fetchedResultsControllerDelegate = StateObject(wrappedValue: FetchedResultsControllerDelegate(fetchedResultsController: fetchedResultsController))
        
        //Resolving SecurityManager using DIContainer
        self.securityManager = DIContainer.shared.resolve(SecurityManagerProtocol.self)!
    }
    
    // DateFormatter for displayig date
    private var entryDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fetchedResultsControllerDelegate.journalEntries, id: \.objectID) { entry in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(decryptContent(entry: entry) ?? "No Content")
                            .font(.headline)
                        if let moodRating = entry.value(forKey: "moodRating") as? Int16 {
                            Text("Mood Rating: \(entry.moodRating)")
                                .font(.subheadline)
                        }
                        if let dateCreated = entry.value(forKey: "dateCreated") as? Date {
                            Text("Entry on \(dateCreated, formatter: entryDateFormatter)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteEntries)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    isShowingAddEntryView = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $isShowingAddEntryView) {
                AddEntryView(isPresented: $isShowingAddEntryView)
                    .environment(\.managedObjectContext, viewContext)
            }
            .navigationTitle("Journal Entries")
        }
    }
            
    @State private var isShowingAddEntryView = false
    
    private func decryptContent(entry: NSManagedObject) -> String? {
        guard let encryptedContent = entry.value(forKey: "content") as? Data else {
            return nil
        }
        do{
            let decryptedData = try securityManager.decrypt(data: encryptedContent)
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            print("Error decrypting content: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func deleteEntries(offsets: IndexSet) {
        let context = CoreDataStack.shared.mainContext
        offsets.map { fetchedResultsControllerDelegate.journalEntries[$0]}.forEach { entry in context.delete(entry)
    }
    
        do{
            try context.save()
        } catch {
            //Handling errors
            print("Error deleting entry: \(error.localizedDescription)")
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //Privde a mock maanged object context for preview
        let context = CoreDataStack.shared.mainContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}

