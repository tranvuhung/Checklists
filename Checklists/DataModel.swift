//
//  DataModel.swift
//  Checklists
//
//  Created by Trần Vũ Hưng on 9/23/17.
//  Copyright © 2017 Tran Vu Hung. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    func documentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadChecklists(){
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path){
            let unArchiver =  NSKeyedUnarchiver(forReadingWith: data)
            lists = unArchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unArchiver.finishDecoding()
            sortChecklist()
        }
    }
    
    func registerDefaults(){
        let dictionary: [String: Any] = ["ChecklistIndex": -1, "FirstTime": true, "ChecklistItemID": 0]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    var indexOfSlectedChecklist: Int{
        get{
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        } set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    func handleFirstTime(){
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime{
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            indexOfSlectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    func sortChecklist(){
        lists.sort { (checklist1, checklist2) -> Bool in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending
        }
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
}
