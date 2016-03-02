//
//  ChecklistItem.swift
//  Checklists
//
//  Created by 1024 on 17.02.16.
//  Copyright © 2016 Sasha Lexor. All rights reserved.
//

import Foundation

// класс для хранения данных о ячейке

class ChecklistItem : NSObject, NSCoding {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
    
    
    override init() {                           // неоьходимо прописать для работы метода nit?(coder aDecoder: NSCoder)
        super.init()
    }
    
    init (text : String) {
        self.text = text
        super.init()
    }
    
    init(text : String, checked : Bool) {
        self.text = text
        self.checked = checked
        super.init()
    }
    
    
    //----------------------------- реализация меотдов NSCoding Protocol ------------------------//
    
    
    // метод для сохранения объекта
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
    }
    
    
    // метод для загрузки объекта
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        
        super.init()
    }
    
    
    
}
