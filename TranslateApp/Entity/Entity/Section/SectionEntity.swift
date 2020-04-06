//
//  SectionEntity.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import UIKit

class SectionEntity {

    static public let Header = SectionEntity(0, title: "Header", isHidden: true)
    static public let Translate = SectionEntity(1, title: "Translate", isHidden: true)
    static public let History = SectionEntity(2, title: "История", subTitle: "Последние переводы", isShowAll: true)
    static public let Language = SectionEntity(3, title: "Перевести ")

    static public func allValues() -> [SectionEntity] {
        return [Header, Translate, History, Language]
    }

    static public func mainValues() -> [SectionEntity] {
        return [Header, Translate, History]
    }
    
    static public func listValues() -> [SectionEntity] {
        return [History, Language]
    }

    static public func getValues(_ sectionType: SectionType = .main) -> [SectionEntity] {
        return values(sectionType)
    }

    static public func getAddValuesIndex(_ sectionType: SectionType = .main, _ type: SectionEntity) -> Int {
        let typeValues = values(sectionType)
        return typeValues.firstIndex(where: { $0.itemId == type.itemId }) ?? 0
    }

    public var itemId: Int
    public var title: String
    public var subTitle: String?
    public var emptyTitle: String
    public var emptySubTitle: String
    public var isHidden: Bool
    public var isShowAll: Bool

    fileprivate init(_ itemId: Int, title: String, subTitle: String? = nil, emptyTitle: String = "", emptySubTitle: String = "", isHidden: Bool = false, isShowAll: Bool = false) {
        self.itemId = itemId
        self.title = title
        self.subTitle = subTitle
        self.emptyTitle = emptyTitle
        self.emptySubTitle = emptySubTitle
        self.isHidden = isHidden
        self.isShowAll = isShowAll
    }

    static public func byId(_ itemId: Int) -> SectionEntity? {
        return allValues().first(where: { $0.itemId == itemId })
    }

    static public func byTitle(_ title: String) -> SectionEntity? {
        return allValues().first(where: { $0.title == title })
    }

    static public func values(_ sectionType: SectionType = .main) -> [SectionEntity] {
        var volues = mainValues()

        let history = volues.first(where: { $0.itemId == History.getId() })
        history?.emptyTitle = "Пусто"
        history?.emptySubTitle = "Нет последних переводов"

        if sectionType == .main {
            volues = mainValues()
        } else if sectionType == .history {
            volues = listValues()
            if let indexLanguage = volues.firstIndex(where: { $0.itemId == Language.itemId }) {
                volues.remove(at: indexLanguage)
            }
        } else if sectionType == .languages {
            volues = listValues()
            history?.emptySubTitle = "Нет языков"
            if let indexHistory = volues.firstIndex(where: { $0.itemId == History.itemId }) {
                volues.remove(at: indexHistory)
            }
        }

        return volues
    }

    func setTitle(_ title: String) {
        self.title = title
    }

    func setSubTitle(_ subTitle: String) {
        self.subTitle = subTitle
    }

    public func getId() -> Int {
        return itemId
    }

    public func getTitle() -> String {
        return title
    }

    public func getSubTitle() -> String {
        return subTitle ?? ""
    }

    public func getIsShowAll() -> Bool {
        return isShowAll
    }

    public func getIsHidden() -> Bool {
        return isHidden
    }
}

