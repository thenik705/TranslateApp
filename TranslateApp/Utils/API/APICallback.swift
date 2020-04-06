//
//  APICallback.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import Foundation

class APICallback: NSObject {

    var completion: (NSObject) -> Void
    var error: (ErrorEntity) -> Void

    init(completion: @escaping (NSObject) -> Void, error: @escaping (ErrorEntity) -> Void) {
        self.completion = completion
        self.error = error
    }

    @objc func onLoaded(_ resultCompletion: NSObject) {
        completion(resultCompletion)
    }

    @objc func onError(_ resultError: ErrorEntity) {
        error(resultError)
    }
}
