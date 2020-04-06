//
//  Button.swift
//  TranslateApp
//
//  Created by Nik on 05.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import UIKit

class Button {

    static func itemButton(_ image: String? = nil, _ title: String? = nil) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))

        let iconView = UIView()
        iconView.frame = CGRect.init(x: 0, y: 0, width: button.frame.width * 0.36, height: button.frame.height * 0.36)
        iconView.center = button.center
        iconView.backgroundColor = #colorLiteral(red: 0.5568627450, green: 0.5568627450, blue: 0.57647058829, alpha: 1)

        if let image = image {
            button.setImage(UIImage(named: image), for: .normal)
        }
        if let title = title {
            button.setTitle(title)
        }

//        button.setTitleColor(UIColor.blue, for: UIControl.State.selected)
        button.applyNavBarConstraints(title)

        return button
    }

    static func systemButton(_ systemImage: String) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let image = Utils.system(systemImage, pointSize: 16, weight: .bold)

        button.setImage(image, for: .normal)

        button.backgroundColor = #colorLiteral(red:0.9372549019, green: 0.9372549019, blue: 0.9568627450, alpha: 1)
        button.layer.cornerRadius = button.frame.width / 2
        button.applyNavBarConstraints()

        return button
    }

    static func closeButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))

        let iconView = SPStorkCloseView()
        iconView.frame = CGRect.init(x: 0, y: 0, width: button.frame.width * 0.36, height: button.frame.height * 0.36)
        iconView.center = button.center
        iconView.color = #colorLiteral(red: 0.5568627450, green: 0.5568627450, blue: 0.57647058829, alpha: 1)

        button.backgroundColor = #colorLiteral(red:0.9372549019, green: 0.9372549019, blue: 0.9568627450, alpha: 1)
        button.layer.cornerRadius = button.frame.width / 2
        button.addSubview(iconView)
        button.applyNavBarConstraints()

        return button
    }
}

extension UIView {
    func applyNavBarConstraints( _ title: String? = nil) {
        let widthConstraint = self.widthAnchor.constraint(equalToConstant: title == nil ? 30 : 100)
        let heightConstraint = self.heightAnchor.constraint(equalToConstant: 30)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }
}

