//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Trần Vũ Hưng on 9/22/17.
//  Copyright © 2017 Tran Vu Hung. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate {
    func listDetaiViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    //MARK: Properties
    
    var delegate: ListDetailViewControllerDelegate?
    var checklistToEdit: Checklist?
    var iconName = "Folder"
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklistEdit = checklistToEdit{
            title = "Edit Checklist"
            textField.text = checklistEdit.name
            doneBarButton.isEnabled = true
            iconName = checklistEdit.iconName
        }
        
        iconImageView.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK: - TextFileDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = newText.length > 0
        
        return true
    }
    
    //MARK: - Delegate Action
    
    @IBAction func cancel(){
        delegate?.listDetaiViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        if let checklistEdit = checklistToEdit {
            checklistEdit.name = textField.text!
            checklistEdit.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: checklistEdit)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
}
