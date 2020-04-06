//
//  IEditPanelButton.swift
//  TranslateApp
//
//  Created by Nik on 02.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import Foundation

@objc public protocol IEditPanelButton: IPanelButton {
    
    func setTitle(_ title: String)
    func setSelect(_ select: Bool)
}
