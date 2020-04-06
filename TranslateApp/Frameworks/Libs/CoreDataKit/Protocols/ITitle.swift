//
//  ITitle.swift
//  TranslateApp
//
//  Created by Nik on 02.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import Foundation

@objc public protocol ITitle: AnyObject {
    
    func  getId() -> NSObject
    func  getTitle() -> String
}
