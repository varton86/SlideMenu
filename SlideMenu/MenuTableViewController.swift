//
//  MenuTableViewController.swift
//  SlideMenu
//
//  Created by Соловьев Олег Витальевич on 19/01/2019.
//  Copyright © 2019 Oleg Soloviev. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    private let menuItems = ["Меню", "1 Пункт Меню", "2 Пункт Меню", "3 Пункт Меню", "4 Пункт Меню", "5 Пункт Меню"]
    private let excludedIndexPathRow = 0
    var currentItem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView =  UIView(frame: CGRect.zero)
        prepareGestureRecognizer()
    }
    
    // MARK: - Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]

        let isSelected = indexPath.row == Int(currentItem)
        cell.textLabel?.textColor = isSelected ? UIColor.white : UIColor.gray
        cell.backgroundColor = isSelected ? UIColor.blue : UIColor.clear

        return cell
    }

    // MARK: - Table view delegate methods

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == excludedIndexPathRow { return nil }
        if let selectedIndexPathRow = Int(currentItem), let cell = tableView.cellForRow(at: IndexPath(row: selectedIndexPathRow, section: 0)) {
            cell.textLabel?.textColor = UIColor.gray
            cell.backgroundColor = UIColor.clear
        }
        return indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == excludedIndexPathRow { return }
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor.blue
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let menuTableViewController = segue.source as! MenuTableViewController
        if let selectedIndexPath = menuTableViewController.tableView.indexPathForSelectedRow {
            currentItem = String(selectedIndexPath.row)
        }
    }
    
    // MARK: - GestureRecognizer methods
    
    private func prepareGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showMainView))
        tapGesture.delegate = self
        tableView.addGestureRecognizer(tapGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(showMainView))
        tableView.addGestureRecognizer(swipeGesture)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let cell = self.tableView.indexPathForRow(at: touch.location(in: self.tableView)), cell.row > 0 {
            return false
        }
        return true
    }
    
    @objc private func showMainView() {
        self.performSegue(withIdentifier: "unwindToHomeWithSegue", sender: self)
    }

}
