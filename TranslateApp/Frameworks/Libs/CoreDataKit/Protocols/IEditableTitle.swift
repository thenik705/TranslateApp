//
//  IEditableTitle.swift
//  TranslateApp
//
//  Created by Nik on 02.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import Foundation

@objc public protocol IEditableTitle: ITitle {
    
    func setTitle(_ title: String)
    func setPosition(position: Int)
}
