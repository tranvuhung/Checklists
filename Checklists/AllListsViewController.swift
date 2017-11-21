//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Trần Vũ Hưng on 9/22/17.
//  Copyright © 2017 Tran Vu Hung. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    
    //MARK: Properties
    //var lists: Array<Checklist>
    /*
    required init?(coder aDecoder: NSCoder) {
        lists = Array<Checklist>()
        
        super.init(coder: aDecoder)
        loadChecklists()
    } */
    
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSlectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel?.text = checklist.name
        let count = checklist.counterUncheckedItem()
        if checklist.items.count == 0 {
            cell.detailTextLabel?.text = "(No Items)"
        } else if count == 0 {
            cell.detailTextLabel?.text = "(All Done!)"
        } else {
            cell.detailTextLabel?.text = "(\(count) Remaining)"
        }
        cell.imageView?.image = UIImage(named: checklist.iconName)
        cell.accessoryType = .detailDisclosureButton

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dataModel.indexOfSlectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell{
        let identifier = "cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        //let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! ListDetailViewController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }
    
    //MARK: Seugue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let viewController = segue.destination as! ChecklistViewController
            viewController.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist"{
            let navigationController = segue.destination as! UINavigationController
            let listViewController = navigationController.topViewController as! ListDetailViewController
            
            listViewController.delegate = self
            listViewController.checklistToEdit = nil
        }
            
    }
    
    //MARK: ListDetailViewControllerDelegate
    
    func listDetaiViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        //let newRowIndex = dataModel.lists.count
        
        dataModel.lists.append(checklist)
        
        //let indexPath = IndexPath(row: newRowIndex, section: 0)
        //let indexPaths = [indexPath]
        //tableView.insertRows(at: indexPaths, with: .automatic)
        
        dataModel.sortChecklist()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        /*
        if let index = dataModel.lists.index(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                cell.textLabel?.text = checklist.name
            }
        }*/
        
        dataModel.sortChecklist()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UINavigationControllerDelegate
extension AllListsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSlectedChecklist = -1
        }
    }
}
