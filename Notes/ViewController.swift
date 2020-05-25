//
//  ViewController.swift
//  Notes
//
//  Created by Ming Xuan on 24/5/20.
//  Copyright © 2020 MX. All rights reserved.
//

import UIKit

// Make sure we go to storyboard -> Click Navigation Controller Scene -> Attributor inspector, Is initial view controller 
class ViewController: UITableViewController {
    // Store in memory a list of Notes
    var notes: [Note] = []
    
    // Refresh our table view 
    func reload() {
        notes = NoteManager.main.getAllNotes()
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
//    @IBAction func createNote() {
//        let _ = NoteManager.main.create()
//        reload()
//    }
    
    // To load whatever is in the database
    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
    }
    
    // Number of sections: 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // How many rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    // Contents in cell 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Make sure same cell doesnt appear twitce
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        // ? means - If variable is nil, ignore this line
        cell.textLabel?.text = notes[indexPath.row].content // Grab the row element
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NoteSegue" {
            if let destination = segue.destination as? NoteViewController {
                destination.note = notes[tableView.indexPathForSelectedRow!.row]
            }
        }
        
        if segue.identifier == "goToNewNote" {
            let _ = NoteManager.main.create()
            reload()
            
            if let destination = segue.destination as? NoteViewController {
                destination.note = notes[notes.count - 1]
            }
        }
   }
    
}

