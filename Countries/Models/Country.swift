//
//  Country.swift
//  Countries
//
//  Created by Vineet Kumar on 2/6/19.
//  Copyright © 2019 Scorpion. All rights reserved.
//

import Foundation

class Country : Codable {
    let name : String
    let flag : String
    let callingCodes : [String]
    let capital : String
    let region : String
    let subregion : String
    let timezones : [String]
    let alpha2Code : String
    let alpha3Code : String
    let nativeName : String
    let demonym : String
    let population : Int64
    let languages : [Language]
    let currencies : [Currency]
}
