//
//  MainViewController.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import UIKit
import CoreDataKit
//import SPAlert

class MainViewController: UIViewController {

    @IBOutlet weak var upViewPanel: UIView!
    @IBOutlet weak var mainTableView: MainTableViewController!

    var selectFromLang: Language?
    var selectToLang: Language?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        initSettings()
    }

    // MARK: - Settings
    func initSettings() {
        initLanguages()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.isNavigationBarHidden = true

        //mainTableView.mainTableDelegate = self
        mainTableView.setController(self)
        mainTableView.loadHistory()
        
        disnissKeyboardWhenTappedAround()
    }

    // MARK: - Additional functions
    func translateText(_ text: String) {
        if text.isNotEmpty() && text.count <= 10000 {
            if let fromLang = selectFromLang, let toLang = selectToLang {
                API().postTranslateText(APICallback(completion: { (result: (NSObject)) in
                    if let history = result as? History {
                        self.mainTableView.setTranslateText(history)
                    }
                }, error: { (resultError: (ErrorEntity)) in
                    print(resultError)
                }), text: text, lang: "\(fromLang.key)-\(toLang.key)")
            }
        }
    }
    
    func initLanguages() {
        let languages = getLanguage()
        if languages.count == 0 {
            API().postGetLangs(APICallback(completion: { (result: (NSObject)) in
                let languages = self.getLanguage()
                if languages.count != 0 {
                    self.selectFromLang = languages.filter({ $0.key == Const.FROM_LANG_KEY_DEFAULT }).first ?? languages[0]
                    self.selectToLang = languages.filter({ $0.key ==  Const.TO_LANG_KEY_DEFAULT }).first ?? languages[1]
                }
            }, error: { (resultError: (ErrorEntity)) in
                print(resultError)
            }))
        } else {
            self.selectFromLang = languages.filter({ $0.key == Const.FROM_LANG_KEY_DEFAULT }).first ?? languages[0]
            self.selectToLang = languages.filter({ $0.key ==  Const.TO_LANG_KEY_DEFAULT }).first ?? languages[1]
        }
    }
    
    func getLanguage() -> [Language] {
        return CoreDataManager.loadFromDb(clazz: Language.self, keyForSort: Const.SORT_ID)
    }
    
    func openListController(_ type: SectionType, isFromTranslate: Bool = false) {
        let controller = Const.GET_STORYBOARD.instantiateViewController(withIdentifier: Const.LIST_VIEW_CONTROLLER) as! ListViewController
        controller.listDelegate = self
        controller.sectionType = type
        controller.langFrom = isFromTranslate ? selectFromLang : nil
        controller.langTo = selectToLang

        let nController = UINavigationController(rootViewController: controller)
        self.present(nController, animated: true, completion: nil)
    }
}

extension MainViewController: SectionDelegate {
    func tappedSection(_ type: SectionType) {
        openListController(type)
    }
}

extension MainViewController: ListTableDelegate {
    func selectLanguageItem(_ lang: Language, _ isFrom: Bool) {
        var isSwap = false
        if isFrom {
            if selectToLang == lang {
                selectToLang = selectFromLang
                isSwap = !isSwap
            }
            selectFromLang = lang
        } else {
            if selectFromLang == lang {
                selectFromLang = selectToLang
                isSwap = !isSwap
            }
            selectToLang = lang
        }

        mainTableView.updateLanguages(isSwap)
    }
    
    func selectHistoryItem(_ history: History) {
        let langKeyArr = history.lang.components(separatedBy: "-")

        if langKeyArr.count == 2 {
            if let keyFrom: String = langKeyArr[0], let keyTo: String = langKeyArr[1] {
                if let fromLang = getLang(keyFrom), let toLang = getLang(keyTo) {
                    selectToLang = toLang
                    selectFromLang = fromLang
                }
            }
        }
        
        mainTableView.loadHistory(history)
    }
    
    func getLang(_ key: String) -> Language? {
        return CoreDataManager.loadFromDbByKey(clazz: Language.self, key: key)
    }
}
