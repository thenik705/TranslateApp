//
//  Language.swift
//  CoreDataKit
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import Foundation
import CoreData

public class Language: DBEntity, ITitle {
    
    @NSManaged public var key: String
    @NSManaged public var name: String
    
    convenience init() {
        self.init(entity: "Language")
    }
    
    public func getId() -> NSObject {
        return id ?? -1
    }
    
    public func getNumberId() -> NSNumber {
        return getId() as! NSNumber
    }
    
    public func getTitle() -> String {
        return name
    }
    
    public func getKey() -> String {
        return key
    }
}
