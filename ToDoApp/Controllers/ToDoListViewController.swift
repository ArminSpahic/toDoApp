//
//  ViewController.swift
//  ToDoApp
//
//  Created by Armin Spahic on 31/03/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    var itemResults: Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
           loadItems()
        }
    }
    
    
    let defaults = UserDefaults.standard
    //let dataPathFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.separatorStyle = .none
        
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
        
         guard let colorHex = selectedCategory?.color else {fatalError()}
                title = selectedCategory?.name
        updateNavBar(hexCode: colorHex)
        
            
        
        }
    func updateNavBar(hexCode: String) {
       
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation bar doesnt exist")}
        guard let navBarColor = UIColor(hexString: hexCode) else {fatalError()}
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:  ContrastColorOf(navBarColor, returnFlat: true) ]
        searchBar.barTintColor = navBarColor
        
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        guard let originalColor = UIColor(hexString: "1D9BF6") else {fatalError()}
//        navigationController?.navigationBar.barTintColor = originalColor
//        navigationController?.navigationBar.tintColor = FlatWhite()
//        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: FlatWhite()]
//    }
    
        
      
       // print(dataPathFile)
        //loadItems()
//        if let items = defaults.array(forKey: "toDoListArray") as! [Item] {
//            itemResults = items
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResults?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemResults?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemResults!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            
            if item.done == true{
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            } }
            else {
                cell.textLabel?.text = "No items added yet"
            }
            
            return cell
            
        }
        
        
      
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let items = itemResults?[indexPath.row] {
            do {
            try realm.write {
                items.done = !items.done
            }
            
            }  catch {
                print("Error saving done status \(error)")
            } }
        tableView.reloadData()
        
        
//        context.delete(itemResults[indexPath.row])
//        itemResults.remove(at: indexPath.row)
       
//        itemResults[indexPath.row].done = !itemResults[indexPath.row].done
//        saveItems()
       
      
            
      
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func alertClose(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addItemBtn(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do{
                    
                 try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
                
                }
            } catch {
                print("Error saving to realm \(error)")
            }            }
            self.tableView.reloadData()
//        let newItem = Item(context: self.context)
//        newItem.title = textField.text!
//        newItem.done = false
//        newItem.parentCategory = self.selectedCategory
//        self.itemResults.append(newItem)
            
//            self.saveItems()
       // self.defaults.set(self.itemResults, forKey: "ToDoListArray")
     
    
        }
        alert.addTextField { (alertTextField) in
           alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion:{
            
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(gesture:))))
            
        })
        
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemsForDelete = itemResults?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemsForDelete)
                }
                
            } catch {
                print("Error deleting category \(error)")
            }
        }
        
    }
    
//    func saveItems() {
//
//
//        do{
//           try context.save()
//        } catch {
//            print("Error in context data, \(error)")
//        }
//        self.tableView.reloadData()
//
//    }
    
    func loadItems() {
       
        itemResults = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        // Item.fetchRequest() is default value if no parameter is given
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//        do{
//       itemResults = try context.fetch(request)
//        } catch {
//            print("Error fetching data \(error)")
//        }
        self.tableView.reloadData()

    }
    

}
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      itemResults = itemResults?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()


    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }

    }

    
    
    
    
    
    
    
}

