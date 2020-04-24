 //
 //  CategoryViewController.swift
 //  Todoey
 //
 //  Created by Muzammil Muneer on 20/04/2020.
 //  Copyright © 2020 App Brewery. All rights reserved.
 //
 
 import UIKit
 import CoreData
 import RealmSwift
 
 class CategoryViewController: UITableViewController {
    
    var categoryArray: Results<Category>?
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added"
        
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
