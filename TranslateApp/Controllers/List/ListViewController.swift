//
//  ListViewController.swift
//  TranslateApp
//
//  Created by Nik on 05.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import UIKit
import CoreDataKit
//import SPAlert

protocol ListTableDelegate: class {
    func selectLanguageItem(_ lang: Language, _ isFrom: Bool)
    func selectHistoryItem(_ history: History)
}

class ListViewController: UIViewController {
    
    weak var listDelegate: ListTableDelegate?
    
    @IBOutlet weak var listTableView: ListTableViewController!
    
    var lightStatusBar = false
    var langFrom: Language?, langTo: Language?
    
    var sectionType: SectionType = .languages
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lightStatusBar = true
        self.navigationController?.isNavigationBarHidden = false
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: - Settings
    func initSettings() {
        let buttonClose = Button.closeButton()
        buttonClose.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        title = getTitle()
        
        listTableView.setController(self)
        listTableView.loadInfo(sectionType)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonClose)
        disnissKeyboardWhenTappedAround()
    }
    
    // MARK: - Additional functions
    func getTitle() -> String {
        var title = ""
        
        switch sectionType {
        case .history:
            title = "История"
        default:
            title = "Языки"
        }
        
        return title
    }
    
    @objc func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.lightStatusBar ? .lightContent : .default
    }
}

