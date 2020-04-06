//
//  HeaderCell.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import UIKit
import CoreDataKit

protocol HeaderCellDelegate: class {
    func selectEditFrom()
    func selectEditTo()
    func selectSwap()
}

class HeaderCell: UITableViewCell {

    static let identifier = "HeaderCell"
     weak var delegate: HeaderCellDelegate?

    @IBOutlet weak var labelLanguageFrom: UILabel!
    @IBOutlet weak var labelLanguageTo: UILabel!
    
    func loadCell(_ from: Language?, _ to: Language?) {
        if let from = from, let to = to {
            labelLanguageFrom.text = from.getTitle()
            labelLanguageTo.text = to.getTitle()
        }
    }

    // MARK: - Actions
    @IBAction func selectFromLanguageButtonAction(_ sender: Any) {
        delegate?.selectEditFrom()
    }

    @IBAction func selectToLanguageButtonAction(_ sender: Any) {
        delegate?.selectEditTo()
    }

    @IBAction func swapLanguageButtonAction(_ sender: Any) {
        delegate?.selectSwap()
    }
}

