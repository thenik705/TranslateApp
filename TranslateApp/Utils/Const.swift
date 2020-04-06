//
//  Const.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import Foundation
import UIKit

class Const {

    // MARK: - Controller
    static var GET_STORYBOARD = UIStoryboard(name: "Main", bundle: nil)

    static var MAIN_VIEW_CONTROLLER = "MAIN_VIEW_CONTROLLER"
    static var LIST_VIEW_CONTROLLER = "LIST_VIEW_CONTROLLER"
    
    // MARK: - KeyNotification

    // MARK: - Config
    static var GROUP_ID = "group.com.nik.translate.container"
    static var FROM_LANG_KEY_DEFAULT = "ru"
    static var TO_LANG_KEY_DEFAULT = "en"
    
    // MARK: - Sort BD
    static var SORT_ID = [NSSortDescriptor(key: "id", ascending: true)]
    static var SORT_DATE = [NSSortDescriptor(key: "date", ascending: false)]
}

