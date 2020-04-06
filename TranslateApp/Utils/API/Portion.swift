//
//  Portion.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import Foundation

class Portion {
    private var limit: Int
    private var offset: Int = 0
    private var loaded = false

    init(limit: Int) {
        self.limit = limit
    }

    func reset() {
        loaded = false
        offset = 0
    }

    func allLoaded() -> Bool {
        return loaded
    }

    func getLimit() -> Int! {
        return limit
    }

    func getOffset() -> Int! {
        return offset
    }

    func reloadOffset(newOffset: Int) {
        loaded = false
        limit = newOffset
        offset = 0
    }

    func loaded(count: Int) {
        offset += count
        if count < limit {
            loaded = true
        }
    }
}

