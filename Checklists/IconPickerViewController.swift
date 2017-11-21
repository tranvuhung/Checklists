//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Trần Vũ Hưng on 9/25/17.
//  Copyright © 2017 Tran Vu Hung. All rights reserved.
//

import Foundation
import UIKit

protocol IconPickerViewControllerDelegate: class {
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    weak var delegate: IconPickerViewControllerDelegate?
    let icons = ["No Icon", "Appointments", "Birthdays", "Chores", "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        let imageName = icons[indexPath.row]
        cell.textLabel?.text = imageName
        cell.imageView?.image = UIImage(named: imageName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }
}
