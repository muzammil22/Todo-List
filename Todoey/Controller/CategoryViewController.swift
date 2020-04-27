 //
 //  CategoryViewController.swift
 //  Todoey
 //
 //  Created by Muzammil Muneer on 20/04/2020.
 //  Copyright © 2020 App Brewery. All rights reserved.
 //
 
 import UIKit
 import RealmSwift
 import SwipeCellKit
 
 class CategoryViewController: UITableViewController {
    
    var categoryArray: Results<Category>?
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        tableView.rowHeight = 80.0
        
    }
    
    //MARK:- Add Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
               
               let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
               
               let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
                   
                   
                
                   let category = Category()
                   category.name = textField.text!
                   
                   self.saveData(category: category)

               }
               
               alert.addTextField { (alertTextField) in
                   textField = alertTextField
                   alertTextField.placeholder = "Create new Item"
               }
               
               alert.addAction(action)
               
               present(alert, animated: true, completion: nil)
    }
    
    //MARK:- TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added"
        cell.delegate = self
        
        
        return cell
    }
    
    //MARK:- TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectdCategory = categoryArray?[indexPath.row]
        }
    
    }
    //MARK:- Model Manipulation Methods
    
    func saveData(category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving data: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
 }

 //MARK:- SwipeTableViewCellDelegate Methods
 
 extension CategoryViewController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Item Deleted")
            
            if let categorySelected = self.categoryArray?[indexPath.row] {
               
                do {
                    try self.realm.write{
                        self.realm.delete(categorySelected)
                    }
                } catch {
                    print("Error saving done status: \(error)")
                }
                
               
            }
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        
        return options
    }
 }
