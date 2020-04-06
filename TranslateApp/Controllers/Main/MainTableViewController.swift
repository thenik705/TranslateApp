//
//  MainTableViewController.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import UIKit
import CoreDataKit

protocol MainTableDelegate: class {
    func tapAddEntity()
    func tapOpenSettings()
}

class MainTableViewController: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    weak var mainTableDelegate: MainTableDelegate?
    
    var sections = Sections.createSections()
    var rootController: MainViewController!
    var histories = [History]()
    var isShowToTranslat = false
    var nowLangTranslate = String()

    // MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSettings()
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = dequeueReusableHeaderFooterView(withIdentifier: TableSectionHeader.identifier) as! TableSectionHeader
        let rowSection = sections[section]
        
        if rowSection.getType().getIsHidden() {
            return UIView()
        }
        
        cell.loadSection(rowSection)
        cell.isShowAllButton(rowSection.getType().getIsShowAll())
        cell.delegate = rootController
        cell.background.backgroundColor = .clear
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowSection = sections[section].getType()
        
        switch rowSection.getId() {
        case SectionEntity.Translate.getId():
            return 2
        case SectionEntity.History.getId():
            return histories.isEmpty ? 1 : (histories.count >= 5 ? 5 : histories.count)
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowSection = sections[indexPath.section].getType()
        
        switch rowSection.getId() {
        case SectionEntity.Header.getId():
            return loadHeaderCell(indexPath)
        case SectionEntity.Translate.getId():
            return loadTranslateCell(indexPath)
        case SectionEntity.History.getId():
            return loadHistoryCell(indexPath)
        default:
            return loadSubstrateCell(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowSection = sections[indexPath.section].getType()

        if rowSection.getId() == SectionEntity.History.getId() {
            if !histories.isEmpty {
                rootController.selectHistoryItem(histories[indexPath.row])
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 && indexPath.row == 1 ? (isShowToTranslat ? UITableView.automaticDimension : 20) : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let rowSection = sections[section].getType()
        return rowSection.getIsHidden() ? 1 : rowSection.getSubTitle().isNotEmpty() ? 60 : 35
    }

    // MARK: - Settings
    func initSettings() {
        dataSource = self
        delegate = self

        estimatedRowHeight = 200
        sectionFooterHeight = 0

        let nib = UINib(nibName: TableSectionHeader.identifier, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: TableSectionHeader.identifier)
    }

    // MARK: - Additional functions
    func setController(_ controller: MainViewController) {
        self.rootController = controller
    }

    func loadHistory() {
        histories = CoreDataManager.loadFromDb(clazz: History.self, keyForSort: Const.SORT_DATE)
        reloadSections(IndexSet(arrayLiteral: 2), with: .automatic)
    }

    func loadHeaderCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: HeaderCell.identifier, for: indexPath) as! HeaderCell
        cell.loadCell(rootController.selectFromLang, rootController.selectToLang)
        cell.delegate = self
        return cell
    }

    func loadTranslateCell(_ indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = dequeueReusableCell(withIdentifier: FromTranslateCell.identifier, for: indexPath) as! FromTranslateCell
            cell.loadCell()
            cell.translateText.textDelegate = self
            cell.delegate = self

            return cell
        } else {
            let cell = dequeueReusableCell(withIdentifier: ToTranslateCell.identifier, for: indexPath) as! ToTranslateCell
            cell.loadCell(isShowToTranslat)
            cell.translateText.textDelegate = self
            cell.delegate = self

            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.layoutMargins.left, bottom: 0, right: 0)
            return cell
        }
    }

    func loadHistoryCell(_ indexPath: IndexPath) -> UITableViewCell {
        if histories.isEmpty {
            return loadSubstrateCell(indexPath)
        }
        
        let cell = dequeueReusableCell(withIdentifier: HistoryCell.identifier, for: indexPath) as! HistoryCell
        let rowHistory = histories[indexPath.row]
        
        cell.loadCell(rowHistory)
        
        return cell
    }

    func loadSubstrateCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: SubstrateCell.identifier, for: indexPath) as! SubstrateCell
        let rowSection = sections[indexPath.section]
        
        cell.loadCell(rowSection.emptyTitle, rowSection.emptySubTitle)
        
        return cell
    }

    func setTranslateText(_ history: History? = nil) {
        if let cellForm = cellForRow(at: IndexPath(row: 0, section: 1)) as? FromTranslateCell, let cellTo = cellForRow(at: IndexPath(row: 1, section: 1)) as? ToTranslateCell {
            nowLangTranslate = history?.lang ?? ""

            let text = history?.toText ?? " "
            
            if text.isNotEmpty() {
                cellTo.translateText.text = text.trim()
            } else {
                cellTo.translateText.text = text
                cellTo.setDetectedText()
                cellTo.updateStatusShowButton(false)
            }
            
            if cellForm.translateText.text == cellTo.translateText.text {
                cellTo.updateStatusShowButton(false)
                detectLanguage(text, cellTo)
            } else {
                if text.isNotEmpty() {
                    cellTo.updateStatusShowButton()
                }
                cellTo.setDetectedText()
                cellTo.layoutIfNeeded()
            }
            
            cellForm.updateTextCount()
        }
    }

    func updateLanguages(_ isSwap: Bool = false) {
        beginUpdates()
        if let cell = cellForRow(at: IndexPath(row: 0, section: 0)) as? HeaderCell {
            cell.loadCell(rootController.selectFromLang, rootController.selectToLang)
        }
        
        if let cellForm = cellForRow(at: IndexPath(row: 0, section: 1)) as? FromTranslateCell, let cellTo = cellForRow(at: IndexPath(row: 1, section: 1)) as? ToTranslateCell {
            if isSwap {
                cellForm.translateText.text = cellTo.translateText.text
            }
            translateText(cellForm.translateText.text)
            cellForm.updateTextCount()
        }

        endUpdates()
    }
    
    func loadHistory(_ history: History) {
        beginUpdates()
        if let cell = cellForRow(at: IndexPath(row: 0, section: 0)) as? HeaderCell {
            cell.loadCell(rootController.selectFromLang, rootController.selectToLang)
        }
        
        if let cellForm = cellForRow(at: IndexPath(row: 0, section: 1)) as? FromTranslateCell, let cellTo = cellForRow(at: IndexPath(row: 1, section: 1)) as? ToTranslateCell {
            cellForm.translateText.text = history.fromText
            cellForm.updateTextCount()
            cellTo.translateText.text = history.toText

            translateText(cellForm.translateText.text)
            updateStatusKeyboard(true)
        }

        endUpdates()
    }
    
    func detectLanguage(_ text: String, _ cell: ToTranslateCell) {
        API().postDetectText(APICallback(completion: { (result: (NSObject)) in
            let returnText = result as? String ?? ""
            
            if let languages = CoreDataManager.loadFromDbByKey(clazz: Language.self, key: returnText) {
                cell.setDetectedText(languages.getTitle())
                cell.layoutIfNeeded()
            }
        }, error: { (resultError: (ErrorEntity)) in
            print(resultError)
        }), text: text)
    }
}

extension MainTableViewController: HeaderCellDelegate {
    func selectEditFrom() {
        rootController?.openListController(.languages, isFromTranslate: true)
    }
    
    func selectEditTo() {
        rootController?.openListController(.languages, isFromTranslate: false)
    }
    
    func selectSwap() {
        let nowFromLang = rootController?.selectFromLang
        let nowToLang = rootController?.selectToLang
        rootController?.selectFromLang = nowToLang
        rootController?.selectToLang = nowFromLang
        updateLanguages(true)
    }
}

extension MainTableViewController: PlaceholderTextViewDelegate, TranslateCellDelegate {
    func tapSaveTranslateButton() {
        if let fromCell = cellForRow(at: IndexPath(row: 0, section: 1)) as? FromTranslateCell, let toCell = cellForRow(at: IndexPath(row: 1, section: 1)) as? ToTranslateCell {
            let history = History()
            history.lang = nowLangTranslate
            history.fromText = fromCell.translateText.text
            history.toText = toCell.translateText.text
            history.date = DateUtils.dateFormatterTime(Date())
            CoreDataManager.instance.saveContext()

            loadHistory()
        }
    }
    
    func nowTextCharsCount(_ count: Int) {
        if let cell = cellForRow(at: IndexPath(row: 0, section: 1)) as? FromTranslateCell {
            cell.updateTextCount(count)
        }
    }

    func tapCloseButton() {
        updateStatusKeyboard(false)
    }

    func isClearText(_ isClear: Bool) {
        if isClear {
            setTranslateText()
        }
    }

    func updateStatusKeyboard(_ isShow: Bool) {
        isShowToTranslateCell(isShow)

        if let cell = cellForRow(at: IndexPath(row: 0, section: 1)) as? FromTranslateCell {
            cell.viewClearTextWidthConstraint.constant = isShow ? 35 : 0
            if !isShow {
                cell.countTextLabel.text = ""
            }

            UIView.animate(withDuration: 0.3) {
                cell.layoutIfNeeded()
                UIView.animate(withDuration: 0.3) {
                    cell.viewClear.alpha = isShow ? 1 : 0
                }
            }
        }
    }
    
    func translateText(_ text: String) {
        rootController.translateText(text)
    }
    
    func isShowToTranslateCell(_ isShow: Bool) {
        if isShowToTranslat != isShow {
            isShowToTranslat = isShow
            beginUpdates()
            if let cell = cellForRow(at: IndexPath(row: 0, section: 1)) as? FromTranslateCell {
                cell.separatorInset = isShowToTranslat ? UIEdgeInsets(top: 0, left: cell.layoutMargins.left, bottom: 0, right: 0) : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            }
            endUpdates()
        }
    }
}
