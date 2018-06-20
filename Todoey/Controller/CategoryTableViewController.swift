//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Ron Davis on 6/19/18.
//  Copyright © 2018 Reactuate Software. All rights reserved.
//

import UIKit
import CoreData

let cCATEGORYCELLID = "CategoryCell"
let TODO_LIST_SEGUE_ID = "goToItems"

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    //MARK: - Tableview Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cCATEGORYCELLID, for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    //MARK: - Saving data
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error fetching items: \(error.localizedDescription)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching items: \(error.localizedDescription)")
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // bring up an alert asking for the category name
        let alert = UIAlertController(title: "Add Todoey Category", message: "", preferredStyle: .alert)
        var textfield = UITextField()
        
        let action = UIAlertAction(title: "Create", style: .default) { (action) in
            // what will happen once the user clicks the add item button
            
            let newItem = Category(context: self.context)
            newItem.name = textfield.text!
            self.categoryArray.append( newItem )
            
            // create a new category item and add to list/database
            self.saveCategories()
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textfield = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: TODO_LIST_SEGUE_ID, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

}
