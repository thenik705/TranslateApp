//
//  SubstrateCell.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import UIKit

class SubstrateCell: UITableViewCell {

    static let identifier = "SubstrateCell"

    @IBOutlet weak var substrateBG: GradientView!

    @IBOutlet weak var substrateTitle: UILabel!
    @IBOutlet weak var substrateBGHeightConstraint: NSLayoutConstraint!

    func loadCell(_ title: String = "", _ subTitle: String = "") {

        substrateTitle.attributedText = attributedLabel(title, subTitle)
        substrateBGHeightConstraint.constant = title.isEmpty ? 80 : 150
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func attributedLabel(_ title: String, _ subTitle: String) -> NSAttributedString {
        let titleAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 23, weight: .bold)]
        let subTitleAttrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .medium)]

        var textAttributedString = NSMutableAttributedString()

        if title.isNotEmpty() {
            textAttributedString = NSMutableAttributedString(string: subTitle.isNotEmpty() ? "\(title) \n" : title, attributes: titleAttrs)
        }

        if subTitle.isNotEmpty() {
            if title.isEmpty {
                textAttributedString = NSMutableAttributedString(string: subTitle, attributes: subTitleAttrs)
            } else {
                let subTextAttributedString = NSMutableAttributedString(string: subTitle, attributes: subTitleAttrs)
                textAttributedString.append(subTextAttributedString)
            }
        }

        return textAttributedString
    }
}
