//
//  HistoryCell.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import UIKit
import CoreDataKit

protocol HistoryCellDelegate: class {
}

class HistoryCell: UITableViewCell {

    static let identifier = "HistoryCell"

    weak var delegate: HistoryCellDelegate?
    
    @IBOutlet weak var nameFromLanguageLabel: UILabel!
    @IBOutlet weak var textFromTranslateLabel: UILabel!
    @IBOutlet weak var nameToLanguageLabel: UILabel!
    @IBOutlet weak var textToTranslateLabel: UILabel!
    @IBOutlet weak var dateTranslateLabel: UILabel!
    
    var rowHistory: History!

    func loadCell(_ history: History) {
        rowHistory = history
        
        let langKeyArr = rowHistory.lang.components(separatedBy: "-")

        if langKeyArr.count == 2 {
            if let from: String = langKeyArr[0], let to: String = langKeyArr[1] {
                nameFromLanguageLabel.text = getLang(from)?.getTitle() ?? "-"
                nameToLanguageLabel.text = getLang(to)?.getTitle() ?? "-"
            }
        }

        textFromTranslateLabel.text = rowHistory.fromText
        textToTranslateLabel.text = rowHistory.toText
        
        dateTranslateLabel.text = DateUtils.getReadableDate(DateUtils.getTimeString(rowHistory.date))
    }
    
    func getLang(_ key: String) -> Language? {
        return CoreDataManager.loadFromDbByKey(clazz: Language.self, key: key)
    }
}

