//
//  ErrorEntity.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import Foundation

class ErrorEntity: NSObject {

    var code: Int
    var message: String

    internal init(_ code: Int, _ message: String) {
        self.code = code
        self.message = message
    }

    func getErrorTitle() -> String {
        var titleError = "Произошла неизвестная ошибка"

        switch code {
        case 401:
            titleError = "Неправильный API-ключ"
        case 402:
            titleError = "API-ключ заблокирован"
        case 404:
            titleError = "Превышено суточное ограничение на объем переведенного текста"
        case 413:
            titleError = "Превышен максимально допустимый размер текста"
        case 422:
            titleError = "Текст не может быть переведен"
        case 501:
            titleError = "Заданное направление перевода не поддерживается"
        default:
            print("API ERROR: NO STATUS CODE: \(String(describing: code))")
        }

        return titleError
    }
}

