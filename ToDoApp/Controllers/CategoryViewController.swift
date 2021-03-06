//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Armin Spahic on 05/04/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       loadCategories()
        tableView.separatorStyle = .none
       
       
        

     
    }
    
  
    //MARK: - Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name ?? "No categories added yet"
            guard let color = UIColor(hexString: category.color) else {fatalError()}
            cell.backgroundColor = color
            
             cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            
            }
        
        return cell
    }
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK - Data Manipulation methods
    
    func saveCategories(category: Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
   func loadCategories() {
    
    categories = realm.objects(Category.self)
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error fetching context \(error)")
//        }
    
    categories = realm.objects(Category.self)
    
  }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDelete = categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDelete)
                }
                
            } catch {
                print("Error deleting category \(error)")
            }
        }
    }
    
    @objc func alertClose(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
      let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
           let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            self.saveCategories(category: newCategory)
            
        }
        alert.addAction(action)
        alert.addTextField { (categoryTextField) in
            textField = categoryTextField
            categoryTextField.placeholder = "Add new category"
        }
        present(alert, animated: true, completion: {
        
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(gesture:))))
             
        })
        
        
        }
    }
    
    


