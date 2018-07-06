//
//  TableViewController.swift
//  JSON-Firebase
//
//  Created by Kelvin Tan on 7/6/18.
//  Copyright © 2018 Kelvin Tan. All rights reserved.
//

import UIKit
import Firebase

class TableViewController: UITableViewController {

    var lists: [ToDo] = []
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Getting referrence to the node of ToDo
        ref = Database.database().reference(withPath: "ToDo")
        
        // Receive updates
        ref?.observe(.value, with: { snapshot in
            // create an empty variable to store the latest data
            var newLists: [ToDo] = []
            
            for child in snapshot.children {
                // Populate properties using datasnapshot
                if let snapshot = child as? DataSnapshot,
                    let newToDo = ToDo(snapshot: snapshot) {
                    newLists.append(newToDo)
                }
            }
            // Replace toDoLists with the latest data
            self.lists = newLists
            self.tableView.reloadData()
        })
    }
    

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Adding Item", message: "", preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            let list = ToDo(id: "", item: text)
            let listRef = self.ref?.child(text.lowercased())
            listRef?.setValue(list.toAnyObject())
        }
        alert.addTextField()
        alert.addAction(save)
        present(alert, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = lists[indexPath.row].item
        
        return cell
    }
    
    override
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDoItem = lists[indexPath.row]
            toDoItem.ref?.removeValue()
        }
    }


}
