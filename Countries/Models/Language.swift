//
//  Language.swift
//  Countries
//
//  Created by Vineet Kumar on 2/6/19.
//  Copyright © 2019 Scorpion. All rights reserved.
//

import Foundation

class Language : Codable {
    let iso639_1: String
    let iso639_2: String
    let name: String
    let nativeName: String
}


class Currency : Codable {
    let code : String?
    let symbol : String?
    let name : String
}
