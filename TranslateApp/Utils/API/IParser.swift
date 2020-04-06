//
//  IParser.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import UIKit
import CoreDataKit

public protocol IParser {
    func parse(_ jsonArray: NSArray) -> NSArray!
    func parse(_ json: NSDictionary) -> NSObject!
}

public class FormParser: IParser {
    public func parse(_ jsonArray: NSArray) -> NSArray! {
        return nil
    }

    public func parse(_ json: NSDictionary) -> NSObject! {
        return nil
    }
}

public class ErrorParser: IParser {
    public func parse(_ jsonArray: NSArray) -> NSArray! {
        return nil
    }

    public func parse(_ json: NSDictionary) -> NSObject! {
        if let message = json["message"] as? String {
            if let code = json["code"] as? Int {
                return ErrorEntity(code, message)
            }
        }

        return nil
    }
}

public class LanguagesParser: IParser {
    public func parse(_ jsonArray: NSArray) -> NSArray! {
        return nil
    }

    public func parse(_ json: NSDictionary) -> NSObject! {
        if let langs = json["langs"] as? NSDictionary {
            if CoreDataManager.loadFromDb(clazz: Language.self, keyForSort: Const.SORT_ID).count == 0 {
                let sortLangs = langs.swiftDictionary.sorted(by: { ($0.value as! String) < ($1.value as! String) })
                
                sortLangs.forEach ({ lang in
                    if let key = lang.key as? String, let value = lang.value as? String {
                        let newLang = Language()
                        newLang.key = key
                        newLang.name = value
                    }
                })

                CoreDataManager.instance.saveContext()
            }
        }

        return nil
    }
}

extension NSDictionary {
    var swiftDictionary: Dictionary<String, Any> {
        var swiftDictionary = Dictionary<String, Any>()

        for key : Any in self.allKeys {
            let stringKey = key as! String
            if let keyValue = self.value(forKey: stringKey){
                swiftDictionary[stringKey] = keyValue
            }
        }

        return swiftDictionary
    }
}

public class TranslateParser: IParser {
    public func parse(_ jsonArray: NSArray) -> NSArray! {
        return nil
    }

    public func parse(_ json: NSDictionary) -> NSObject! {
        var allText = ""

        if let translateTexts = json["text"] as? NSArray {
            translateTexts.forEach({ translateText in
                if let text = translateText as? String {
                    allText += "\(text) "
                }
            })
        }

        if let lang = json["lang"] as? String {
            if allText.isNotEmpty() {
                let history = History(entity: CoreDataManager.instance.entityForName(entityName: "History"), insertInto: nil)
                history.lang = lang
                history.toText = allText.trim()
                return history
            }
        }

        return nil
    }
}

public class DetectTextParser: IParser {
    public func parse(_ jsonArray: NSArray) -> NSArray! {
        return nil
    }

    public func parse(_ json: NSDictionary) -> NSObject! {
        if let lang = json["lang"] as? String {
             return lang as NSObject
        }

        return "" as NSObject
    }
}

