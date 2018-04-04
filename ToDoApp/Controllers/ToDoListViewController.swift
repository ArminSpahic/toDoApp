//
//  ViewController.swift
//  ToDoApp
//
//  Created by Armin Spahic on 31/03/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    //let dataPathFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
      
       // print(dataPathFile)
        //loadItems()
//        if let items = defaults.array(forKey: "toDoListArray") as! [Item] {
//            itemArray = items
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
      cell.textLabel?.text = item.title
        
        if item.done == true{
            cell.accessoryType = .checkmark
        } else {
         cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
       
      
            
      
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    @IBAction func addItemBtn(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
        
        let newItem = Item(context: self.context)
        newItem.title = textField.text!
        newItem.done = false
        self.itemArray.append(newItem)
            
            self.saveItems()
       // self.defaults.set(self.itemArray, forKey: "ToDoListArray")
     
    
        }
        alert.addTextField { (alertTextField) in
           alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveItems() {
        
        
        do{
           try context.save()
        } catch {
            print("Error in context data, \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadItems() {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
       itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }

    }
    

}
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = 
    }
    
    
    
    
    
    
    
    
}

