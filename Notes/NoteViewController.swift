//
//  NoteViewController.swift
//  Notes
//
//  Created by Ming Xuan on 24/5/20.
//  Copyright © 2020 MX. All rights reserved.
//

import Foundation
import UIKit

class NoteViewController: UIViewController {
    var note: Note!
    
    @IBOutlet var textView: UITextView!
    
    @IBAction func deleteNote() {
        NoteManager.main.delete(note: note)
        // Go back to ViewContoller
        navigationController?.popViewController(animated: true)
    }
    
    // Update text view
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = note.content
    }
    
    // Before returning to main screen, save the Note
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        note.content = textView.text
        NoteManager.main.save(note: note)
    }

}
