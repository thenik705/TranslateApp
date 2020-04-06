//
//  Portion.swift
//  TranslateApp
//
//  Created by Nik on 02.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import Foundation

public class Portion {
    
    private var limit: Int
    private var offset: Int = 0
    private var loaded = false
    
    init(limit: Int) {
        self.limit = limit
    }
    
    public func reset() {
        loaded = false
        offset = 0
    }
    
    public func allLoaded() -> Bool {
        return loaded
    }
    
    public func getLimit() -> Int! {
        return limit
    }
    
    public func getOffset() -> Int! {
        return offset
    }
    
    public func reloadOffset(newOffset: Int) {
        loaded = false
        limit = newOffset
        offset = 0
    }
    
    public func loaded(count: Int) {
        offset += count
        if count < limit {
            loaded = true
        }
    }
}



