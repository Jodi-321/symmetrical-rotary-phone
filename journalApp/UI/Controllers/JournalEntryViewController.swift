//
//  JournalEntryViewController.swift
//  journalApp
//
//  Created by admin on 8/30/24.
//

import Foundation
import UIKit

class JournalEntryViewController: UIViewController {
    private var viewModel: JournalEntryViewModel
    
    //Custom init that takes a ViewModel
    init(viewModel: JournalEntryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    //Required init for using Storyboards - Xcode
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetch journal entries and update UI
        fetchAndDisplayEntries()
    }
    
    @IBAction func addEntryButtonTapped(_ sender: UIButton) {
        addNewEntry()
    }
    
    private func fetchAndDisplayEntries() {
        let entries = viewModel.fetchAllEntries()
        
        //Update UI with fetched entries
        // Example: use a tableView or collectionView to display entries
        print(entries) //Placeholder: replce with actual UI code to display entries
    }
    
    private func addNewEntry() {
        let result = viewModel.addJournalEntry(content: "New Entry", moodRating: 4)
        switch result {
        case .success(let entry):
            print("Entry added: \(entry)")
            
            //refresh UI or update the list with the new entry
        case .failure(let error):
            print("Failed to add entry: \(error)")
        }
    }
}
