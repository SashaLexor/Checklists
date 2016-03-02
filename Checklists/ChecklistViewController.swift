//
//  ViewController.swift
//  Checklists
//
//  Created by 1024 on 16.02.16.
//  Copyright © 2016 Sasha Lexor. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    // массив для хранения значений
    var checklist: Checklist!
    
    
    
    //----------------------------------------------------------------------- Переопределенные методы класса UIViewController Class ----------------------------------------------//
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Уведоляет ViewController о том, что будет выполнен переходк другому ViewController через segue
    // тут отличное место для установки ДЕЛЕГАТА (или конфигурирования) загружаемого ViewController
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AddItem" {                                                         // переход для добавления эл-та
            let navigationController = segue.destinationViewController as! UINavigationController  // получаем navigationController с явным приведением типа
            let controller = navigationController.topViewController as! ItemDetailViewController   // получаем controller находящийся первым в navigationController с явным приведением типа
            controller.delegate = self                                                             // устанавливаем ДЕЛЕГАТА для полученного контроллера
        } else if segue.identifier == "EditItem" {                                                 // переход для редактирования эл-та
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }

      

    

    
    //----------------------------------------------------------------------- UITableViewDataSource Protocol ----------------------------------------------//
    
    
    
    // задаем кол-во строк (т.е. именно кол-во данных) в таблице = кол-ву элементов в массиве "items"
    // этот метод реализует протокол UITableViewDataSource Protocol
    
    override func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    
    // создается ячейка таблицы и заполняется данными
    // этот метод реализует протокол UITableViewDataSource Protocol
    
    override func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        let item = checklist.items[indexPath.row]
        
        configureTextForCell(cell, withChecklistItem: item)             // ф-ция заполнения поля lable в ячейке
        configureCheckmarkForCell(cell, withChecklistItem: item)        // ф-ция заполнения поля check (галочки) в ячейке
        
        return cell
    }
    
    // Функция вызывается при удалении ячейки свайпом и нажатии кнопки delete
    // этот метод реализует протокол UITableViewDataSource Protocol
    
    override func tableView (tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        checklist.items.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)

    }
    
    
    
     //----------------------------------------------------------------------- UITableViewDelegate Protocol ----------------------------------------------//
    
    
    
    
    // Этот метод вызывается прри нажатии (выборе) конкретной ячейки
    // этот метод реализует протокол UITableViewDelegate Protocol
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {      // извлечение опциональной ячейки, если ячейку удалось получить по indexPath
            let item = checklist.items[indexPath.row]                   // получаем эл-т массива соответствующий выбраноой ячейки
            item.toggleChecked()                                        // вызываем метож эл-та для измения свойства checked
            configureCheckmarkForCell(cell, withChecklistItem: item)    // отображение измененных данных в ячейке
        }
            
        tableView.deselectRowAtIndexPath(indexPath, animated: true)     // снимаем выделение с ячейки

    }
    
  
    
    //----------------------------------------------------------------------- Собственные функции -----------------------------------------------------//
    
    
    
    // Конфигурация lable (галочка) в ячейке в соответствии с данными нах-ся в массиве
    
    func configureCheckmarkForCell (cell : UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    
    // Конфигурация lable (с текстом) в ячейке в соответствии с данными нах-ся в массиве
    
    func configureTextForCell (cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    
    
    //-------------------------------------------------------- Реализация собственного протокола ItemDetailViewControllerDelegate -----------------------------------------//
    
    
    
    // вызывается при нажатии кнопки "cancel" при добавлении или редактировании записи
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil) // скрыть контроллер
    }
    
    
    // вызывается при нажатии кнопки "done" при ДОБАВЛЕНИИ записи
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = checklist.items.count                                                     // получем номер строки для новой ячейки
        checklist.items.append(item)                                                                // добавляем новую запись в массив items
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)                    // создаем indexPath для новой строки
        let indexPaths = [indexPath]                                                      // создаем массив из 1го эл-та для передачи в ф-цию
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)        // вставляем новую ячейку таблицы по затанному indexPath
                    
        controller.dismissViewControllerAnimated(true, completion: nil)                   // скрываем старый viewController

    }
    
    
    // вызывается при нажатии кнопки "done" при РЕДАКТИРОВАНИИ записи
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        if let index = checklist.items.indexOf(item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
}


