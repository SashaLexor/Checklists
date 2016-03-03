//
//  DataModel.swift
//  Checklists
//
//  Created by 1024 on 23.02.16.
//  Copyright © 2016 Sasha Lexor. All rights reserved.
//

import Foundation


class DataModel {
    
    var lists = [Checklist]()
    
    var indexOfSelectedChecklist : Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey( "ChecklistIndex")
        }
        
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
        }
    }
    
    
    func registerDefaults () {
        let dictionary = ["ChecklistIndex": -1, "FirstTime" : true, "ChecklistItemID" : 0]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
        
    }
    
    
    
    init () {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    //-------------------------------------------------------- Работа с сохранением данных в памяти устройства -----------------------------------------//
    
    
    // получаем полный путь к папке документов
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        return paths[0]
    }
    
    
    // метод создающий путь (на основе documentsDirectory()) к файлу Checklists.plist который будет хранить данные
    
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("Checklists.plist") // "\(documentsDirectory())/Checklists.plist"
    }
    
    
    // получаем содержимое массива items, в 2 этапа конвертируем в бинарный блок и затем записываем в фаил
    
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)     // кодируем массив и данные в нем в бинарный формат, который может быть записан в файл
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    
    // загрузка значений в масиив items из файла Checklists.plist
    
    func loadChecklists() {
        let path = dataFilePath()                                                               // получаем путь к файлу Checklists.plist
        if NSFileManager.defaultManager().fileExistsAtPath(path) {                              // проверяем существование файла Checklists.plist
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)                    // если фаил сущестуем, то загружем его содержимое и декодируем его
                lists = unarchiver.decodeObjectForKey("Checklists") as! [Checklist]
                
                unarchiver.finishDecoding()
                
                sortChecklists()
            }
        }
    }
    
    
    func handleFirstTime () {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.setBool(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    
    func sortChecklists() {
        lists.sortInPlace({checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == .OrderedAscending})
    }
    
    
    // создаем уникальный ключ для каждой записи
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaults.integerForKey("ChecklistItemID")
        userDefaults.setInteger(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }

}