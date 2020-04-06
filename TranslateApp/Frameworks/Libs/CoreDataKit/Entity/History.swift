//
//  History.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import Foundation
import CoreData

public class History: DBEntity, ITitle {

    @NSManaged public var lang: String
    @NSManaged public var fromText: String
    @NSManaged public var toText: String
    @NSManaged public var date: String
    
    convenience init() {
        self.init(entity: "History")
    }

    public func getId() -> NSObject {
        return id ?? -1
    }

    public func getNumberId() -> NSNumber {
        return getId() as! NSNumber
    }

    public func getTitle() -> String {
        return fromText
    }
}
