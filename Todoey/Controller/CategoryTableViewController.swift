//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Ron Davis on 6/19/18.
//  Copyright © 2018 Reactuate Software. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

let TODO_LIST_SEGUE_ID = "goToItems"

class CategoryTableViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        self.tableView.separatorStyle = .none
    }
    
    //MARK: - Tableview Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yes"
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colorInHex ?? "0x000")
        
        return cell
    }
    
    //MARK: - Saving data
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error fetching items: \(error.localizedDescription)")
        }
    }
    
    func loadCategories() {
        categories =  realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let delCategory = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(delCategory)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // bring up an alert asking for the category name
        let alert = UIAlertController(title: "Add Todoey Category", message: "", preferredStyle: .alert)
        var textfield = UITextField()
        
        let action = UIAlertAction(title: "Create", style: .default) { (action) in
            // what will happen once the user clicks the add item button
            
            let newCategory = Category()
            newCategory.name = textfield.text!
            newCategory.colorInHex = UIColor.randomFlat.hexValue()
            
            // create a new category item and add to list/database
            self.save(category: newCategory)
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
        // go to next to do item screen
        performSegue(withIdentifier: TODO_LIST_SEGUE_ID, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}


