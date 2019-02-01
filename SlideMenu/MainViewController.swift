//
//  ViewController.swift
//  SlideMenu
//
//  Created by Соловьев Олег Витальевич on 19/01/2019.
//  Copyright © 2019 Oleg Soloviev. All rights reserved.
//

import UIKit

@objc protocol MenuTransitionManagerDelegate: class {
    func dismiss()
}

class MainViewController: UIViewController, MenuTransitionManagerDelegate {

    private let menuTransitionManager = MenuTransitionManager()
    
    @IBOutlet weak var labelText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Заголовок"
        self.labelText.text = ""
        prepareGestureRecognizer()
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        let sourceController = segue.source as! MenuTableViewController
        self.labelText.text = sourceController.currentItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let menuTableViewController = segue.destination as! MenuTableViewController
        menuTableViewController.currentItem = self.labelText.text!
        menuTableViewController.transitioningDelegate = menuTransitionManager
        menuTransitionManager.delegate = self
    }
    
    // MARK: - MenuTransitionManagerDelegate methods
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - GestureRecognizer methods

    private func prepareGestureRecognizer() {
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(showMenu))
        view.addGestureRecognizer(gesture)
    }

    @objc private func showMenu() {
        self.performSegue(withIdentifier: "showMenu", sender: self)
    }

}
