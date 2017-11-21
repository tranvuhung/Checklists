//
//  ViewController.swift
//  Checklists
//
//  Created by Trần Vũ Hưng on 9/15/17.
//  Copyright © 2017 Tran Vu Hung. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    //MARK: Properties
    //var items: [ChecklistItem]
    var checklist: Checklist!
    /*
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        super.init(coder: aDecoder)
        loadChecklistItem()
        //print(dataFilePath())
    } */
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = checklist.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    func loadChecklistItem(){
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path){
            let unArchiver =  NSKeyedUnarchiver(forReadingWith: data)
            items = unArchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
            unArchiver.finishDecoding()
        }
    }*/
    
    //MARK: Tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        //saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //saveChecklistItems()
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem){
        
        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        //label.text = "\(item.itemID): \(item.text)"
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! ItemDetailViewController
            
            viewController.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! ItemDetailViewController
            
            viewController.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                viewController.itemEdit = checklist.items[indexPath.row]
            }
        }
    }
}

//MARK: - ItemDetailViewControllerDelegate
extension ChecklistViewController {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(item: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
        //saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureText(for: cell, with: item)
            }
        }
        
        dismiss(animated: true, completion: nil)
        //saveChecklistItems()
    }
}

//MARK: - Save and loading Item
/*
extension ChecklistViewController {
    func documentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
}
*/
