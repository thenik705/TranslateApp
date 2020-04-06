//
//  Utils.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import UIKit

open class Utils {
    static func hideKeyboard(_ view: UIView) {
        view.endEditing(true)
    }

    static func system(_ name: String, pointSize: CGFloat, weight: UIImage.SymbolWeight) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        return UIImage(systemName: name, withConfiguration: config)
    }
}

extension UILabel {
    func countLabelLines() -> Int {
        let myText = self.text! as NSString
        let attributes = [NSAttributedString.Key.font : self.font]
        let labelSize = myText.boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude),
                                            options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                            attributes: attributes as [NSAttributedString.Key : Any],
                                            context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }

    func isTruncated() -> Bool {

        if (self.countLabelLines() > self.numberOfLines) {
            return true
        }
        return false
    }
}

extension UIViewController {
    func disnissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.disnissKeyboardTappedAround(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func disnissKeyboardTappedAround(_ gestureRecognizer: UIPanGestureRecognizer) {
        dismissKeyboard()
    }

    func dismissKeyboard() {
        Utils.hideKeyboard(self.view)
    }
}
