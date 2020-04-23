 //
 //  CategoryViewController.swift
 //  Todoey
 //
 //  Created by Muzammil Muneer on 20/04/2020.
 //  Copyright © 2020 App Brewery. All rights reserved.
 //
 
 import UIKit
 import CoreData
 
 class CategoryViewController: UITableViewController {
    
    var categoryArray = [`Category`]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    //MARK:- Add Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
               
               let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
               
               let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
                   
                   let category = Category(context: self.context)
                   category.name = textField.text!
                   
                   self.categoryArray.append(category)
                   self.saveData()

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
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    //MARK:- TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectdCategory = categoryArray[indexPath.row]
        }
    
    }
    //MARK:- Model Manipulation Methods
    
    func saveData(){
        
        do{
            try context.save()
        }catch{
            print("Error saving data: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
        
        tableView.reloadData()
    }
    
 }
