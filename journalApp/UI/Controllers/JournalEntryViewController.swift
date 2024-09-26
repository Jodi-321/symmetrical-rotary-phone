//
//  JournalEntryViewController.swift
//  journalApp
//
//  Created by admin on 8/30/24.
//

import Foundation
import UIKit

class JournalEntryViewController: UIViewController, UITableViewDataSource {
    private let viewModel = JournalEntryViewModel(journalManager: DIContainer.shared.resolve(JournalManagerProtocol.self)!)
    private var entries: [JournalEntry] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        fetchAndDisplayEntries()
    }
    
    private func fetchAndDisplayEntries() {
        viewModel.fetchAllEntries {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entries):
                    self?.entries = entries
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch entries: \(error.localizedDescription)")
                    // Present an alert to the user coming here ********
                }
            }
        }
    }
    
    private func addNewEntry() {
        viewModel.addJournalEntry(content: "New Entry", moodRating: 4) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let entry):
                    print("Entry added: \(entry)")
                    self?.entries.append(entry)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to add entry: \(error.localizedDescription)")
                    // Will add user alert here *******
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JournalEntryCell", for: indexPath)
        let entry = entries[indexPath.row]
        if let contentData = entry.content,
           let contentString = String(data: contentData, encoding: .utf8) {
            cell.textLabel?.text = contentString
        } else {
            cell.textLabel?.text = "No Content"
        }
        return cell
    }
}
