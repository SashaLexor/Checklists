//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by 1024 on 20.02.16.
//  Copyright © 2016 Sasha Lexor. All rights reserved.
//

import UIKit


//------------------------------------------------------- определяем собственный протокол для делегата ItemDetailViewController ------------------------------//

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}




class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var itemToEdit: ChecklistItem?
    
    
//----------------------------------------------------------------------- Переопределенные методы класса UITableViewController Class ----------------------------------------------//
    
    
    // выывается перед тем как viewбудет показан (станем видимым)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        textField.becomeFirstResponder()
    }
    
    
    // вызывается когда view загружен, перед его отображением
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true
        }
    }

    
    
    
//---------------------------------------------- action функции ------------------------------------------------//
    
    // нажатие кнопки cancel
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    
    // нажатие кнопки done
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }        
    }
    
    

    
//----------------------------------------------------------------------- UITableViewDelegate Protocol ----------------------------------------------//
    
    
    // вызывается при попытке выбора ячейки
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil // означает что ячейка не может быть выбранна
    }
    
    
//----------------------------------------------------------------------- UITextFieldDelegate Protocol ----------------------------------------------//
    
    
    // every time the user changes the text, whether by tapping on the keyboard or by cut/paste

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText : NSString = textField.text!
        let newText : NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
    
    
    
}