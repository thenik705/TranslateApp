//
//  ListTableViewController.swift
//  TranslateApp
//
//  Created by Nik on 05.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import UIKit
import CoreDataKit

class ListTableViewController: UITableView, UITableViewDataSource, UITableViewDelegate {

    var sections = [Sections]()
    var rootController: ListViewController!
    var nowSectionType: SectionType = .history
    var items = [ITitle]()

    // MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSettings()
    }
    
    // MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.isEmpty ? 1 : items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowSection = sections[indexPath.section].getType()
        
        switch rowSection.getId() {
        case SectionEntity.Language.getId():
            return loadLanguageCell(indexPath)
        case SectionEntity.History.getId():
            return loadHistoryCell(indexPath)
        default:
            return loadSubstrateCell(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowItem = items[indexPath.row]
        if isLanguges() {
            rootController.listDelegate?.selectLanguageItem(rowItem as! Language, isFromLanguges())
        } else {
            rootController.listDelegate?.selectHistoryItem(rowItem as! History)
        }
        rootController.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let rowSection = sections[section].getType()
        if rowSection === SectionEntity.Language {
            let title = rowSection.getTitle() + (isFromLanguges() ? "с" : "на")
            return title
        }
        return nil
    }
    
    // MARK: - Settings
    func initSettings() {
        dataSource = self
        delegate = self

        estimatedRowHeight = 200
    }
    
    // MARK: - Additional functions
    func setController(_ controller: ListViewController) {
        self.rootController = controller
    }
    
    func loadLanguageCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: LanguageCell.identifier, for: indexPath) as! LanguageCell
        let rowLanguage = items[indexPath.row] as! Language

        cell.loadCell(rowLanguage)
        cell.accessoryType = isFromLanguges() ?
            (rowLanguage == rootController.langFrom ? .checkmark : .none) :
            (rowLanguage == rootController.langTo ? .checkmark : .none)

        return cell
    }

    func loadHistoryCell(_ indexPath: IndexPath) -> UITableViewCell {
        if items.isEmpty {
            return loadSubstrateCell(indexPath)
        }
        
        let cell = dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
        let rowHistory = items[indexPath.row] as! History

        cell.loadCell(rowHistory)

        return cell
    }

    func loadSubstrateCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: SubstrateCell.identifier, for: indexPath) as! SubstrateCell
        let rowSection = sections[indexPath.section]
        
        cell.loadCell(rowSection.emptyTitle, rowSection.emptySubTitle)
        
        return cell
    }
    
    func loadInfo(_ sectionType: SectionType = .history) {
        nowSectionType = sectionType
        sections = Sections.createSections(nowSectionType)
        
        if sectionType == .languages {
            items = CoreDataManager.loadFromDb(clazz: Language.self, keyForSort: Const.SORT_ID)
        } else {
            items = CoreDataManager.loadFromDb(clazz: History.self, keyForSort: Const.SORT_DATE)
        }
        
        UIView.transition(
            with: self,
            duration: 0.3,
            options: [.transitionCrossDissolve, UIView.AnimationOptions.beginFromCurrentState],
            animations: {
                self.reloadData()
        })
    }
    
    func isLanguges() -> Bool {
        return nowSectionType == .languages
    }
    
    func isFromLanguges() -> Bool {
        return rootController.langFrom != nil
    }
}
