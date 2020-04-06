//
//  TranslateCell.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import UIKit

protocol TranslateCellDelegate: class {
    func tapCloseButton()
    func tapSaveTranslateButton()
}

class FromTranslateCell: UITableViewCell {

    static let identifier = "FromTranslateCell"
    weak var delegate: TranslateCellDelegate?
    
    @IBOutlet weak var countTextLabel: UILabel!
    
    @IBOutlet weak var translateText: KMPlaceholderTextView!
    @IBOutlet weak var viewClear: UIView!
    @IBOutlet weak var viewClearTextWidthConstraint: NSLayoutConstraint!

    func loadCell() {
    }

    // MARK: - Actions
    @IBAction func clearTextButtonAction(_ sender: Any) {
        if !translateText.text.isEmpty {
            translateText.text = ""
        } else {
            delegate?.tapCloseButton()
            Utils.hideKeyboard(self)
        }
    }
    
    func updateTextCount(_ count: Int? = nil) {
        let count = count ?? translateText.text.count
        let nowCount = 10000 - count
        countTextLabel.textColor = nowCount < 0 ? .systemRed : #colorLiteral(red: 0.6392156863, green: 0.6392156863, blue: 0.6431372549, alpha: 1)
        countTextLabel.text = nowCount == 10000 ? nil : "\(nowCount)"
    }
}

class ToTranslateCell: UITableViewCell {

    static let identifier = "ToTranslateCell"
    weak var delegate: TranslateCellDelegate?
    
    @IBOutlet weak var translateText: KMPlaceholderTextView!
    @IBOutlet weak var viewTranslate: UIView!
    @IBOutlet weak var viewTranslateWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var detectedLabel: UILabel!
    @IBOutlet weak var detectedLabelHeightConstraint: NSLayoutConstraint!

    func loadCell(_ isShowToTranslat: Bool) {
        if !isShowToTranslat {
            translateText.text = ""
            setDetectedText()
        }
    }
    
    // MARK: - Actions
    @IBAction func translateTextButtonAction(_ sender: Any) {
        delegate?.tapSaveTranslateButton()
    }

    func updateStatusShowButton(_ isShow: Bool = true) {
        viewTranslateWidthConstraint.constant = isShow ? 35 : 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                self.viewTranslate.alpha = isShow ? 1 : 0
            }
        }
    }
    
    func setDetectedText(_ text: String? = nil) {
        detectedLabel.text = text?.isNotEmpty() ?? false ? "Язык оригинала: \(text!)" : ""
        detectedLabelHeightConstraint.constant = text?.isNotEmpty() ?? false ? 25 : 0
    }
}
