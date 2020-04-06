//
//  API.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import Foundation
import Alamofire

class API {

    static let BASE_URL = "https://translate.yandex.net/api/v1.5"

    static let REST_GET_LANGS = "/tr.json/getLangs"
    static let REST_TRANSLATE = "/tr.json/translate"
    static let REST_DETECT = "/tr.json/detect"
    
    func postGetLangs(_ callback: NSObject) {
        postRequest(callback, url: API.REST_GET_LANGS, parameters: nil, parser: LanguagesParser())
    }

    func postTranslateText(_ callback: NSObject, text: String, lang: String) {
        let parameters = ["text": text, "lang": lang]
        performRequest(callback, API.REST_TRANSLATE, method: .post, parameters: parameters, parser: TranslateParser())
    }
    
    func postDetectText(_ callback: NSObject, text: String) {
        let parameters = ["text": text]
        performRequest(callback, API.REST_DETECT, method: .post, parameters: parameters, parser: DetectTextParser())
    }
    
    func postRequest(_ callback: NSObject, url: String, parameters: [String: String]? = nil, parser: IParser) {
        performRequest(callback, url, method: .post, parameters: parameters, parser: parser)
    }

    func performRequest(_ callback: NSObject, _ url: String, method: HTTPMethod, parameters: [String: String]? = nil, parser: IParser) {
        let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        var postParameters = ["key": "trnsl.1.1.20200402T135528Z.3c5f4131eb577c3a.49ca47ce6643fefea16c7b13d70adb55f929a7da",
                          "ui": "ru"]

        if let parameters = parameters {
            parameters.forEach ({ parameter in
                if let key = parameter.key as? String, let value = parameter.value as? String {
                   postParameters[key] = value
                }
            })
        }

        AF.request(API.BASE_URL + url, method: method, parameters: postParameters, encoder: URLEncodedFormParameterEncoder.default, headers: headers).responseData { response in
            do {
                if let data = response.data {

                    if response.error != nil {
                        return
                    }

                    if let ipString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                        if let jsonData = ipString.data(using: String.Encoding.utf8.rawValue,allowLossyConversion: true) {
                            let data = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)

                            if (data is NSArray) {
                                let dataArray = data as! NSArray
                                if let error = ErrorParser().parse(dataArray) {
                                    callback.performSelector(onMainThread: #selector(APICallback.onError(_:)), with: error, waitUntilDone: false)
                                } else {
                                    let result = parser.parse(dataArray)
                                    callback.performSelector(onMainThread: #selector(APICallback.onLoaded(_:)), with: result, waitUntilDone: false)
                                }
                            } else if (data is NSDictionary) {
                                let dataDictionary = data as! NSDictionary
                                if let error = ErrorParser().parse(dataDictionary) {
                                    callback.performSelector(onMainThread: #selector(APICallback.onError(_:)), with: error, waitUntilDone: false)
                                } else {
                                    let result = parser.parse(dataDictionary)
                                    callback.performSelector(onMainThread: #selector(APICallback.onLoaded(_:)), with: result, waitUntilDone: false)
                                }
                            }
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}

