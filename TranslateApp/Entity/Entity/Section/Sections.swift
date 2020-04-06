//
//  Sections.swift
//  TranslateApp
//
//  Created by Nik on 04.04.2020.
//  Copyright © 2020 Nik. All rights reserved.
//

import Foundation

enum SectionType {
    case main
    case history
    case languages
}

class Sections {

    var itemId: Int
    var title: String
    var subTitle: String
    var emptyTitle: String
    var emptySubTitle: String

    init(_ itemId: Int, _ title: String, _ subTitle: String, emptyTitle: String = "", emptySubTitle: String = "") {
        self.itemId = itemId
        self.title = title
        self.subTitle = subTitle
        self.emptyTitle = emptyTitle
        self.emptySubTitle = emptySubTitle
    }

    static func createSections(_ sectionType: SectionType = .main) -> [Sections] {
        var sections = [Sections]()

        for section in SectionEntity.getValues(sectionType) {
            sections.append(Sections(section.getId(), section.getTitle(), section.getSubTitle(), emptyTitle: section.emptyTitle, emptySubTitle: section.emptySubTitle))
        }

        return sections
    }

     func isEmpty() -> Bool {
        return count() == 0
    }

    func getId() -> Int {
        return itemId
    }

    func count() -> Int {
        return 1
    }

    func getType() -> SectionEntity {
        return SectionEntity.byId(itemId) ?? SectionEntity.History
    }
}

