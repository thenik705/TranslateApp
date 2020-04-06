//
//  LanguageCell.swift
//  TranslateApp
//
//  Created by Nik on 05.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import UIKit
import CoreDataKit

protocol LanguageCellDelegate: class {
}

class LanguageCell: UITableViewCell {

    static let identifier = "LanguageCell"

    weak var delegate: LanguageCellDelegate?

    var rowLanguage: Language!

    func loadCell(_ language: Language) {
        rowLanguage = language

        textLabel?.text = rowLanguage.getTitle()
        detailTextLabel?.text = rowLanguage.getKey()
    }
}

