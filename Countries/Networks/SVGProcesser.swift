//
//  SVGProcesser.swift
//  Countries
//
//  Created by Vineet Kumar on 2/6/19.
//  Copyright © 2019 Scorpion. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit
import SVGKit

struct SVGProcessor : ImageProcessor {
    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> Image? {
        switch item {
        case .image( let image):
            return image
        case .data( let data):
            return SVGKImage(data: data)?.uiImage
        }
    }
    
    let size: CGSize
    
    // `identifier` should be the same for processors with same properties/functionality
    // It will be used when storing and retrieving the image to/from cache.
    let identifier : String
    
    init(size: CGSize = CGSize(width:30, height:30), identifier: String) {
        self.identifier = identifier
        self.size = size
    }
}

extension UIImageView {
    func downloadFlag(country : Country) {
        if country.flag.contains("shn.svg") {
            //BAD svg
            self.image = nil
            return
        }
        let size = self.frame.size
        self.kf.setImage(with: URL(string: country.flag), placeholder: nil, options: [.processor(SVGProcessor(size:size, identifier:country.alpha3Code))])
    }
    
    func thumbnail(country : Country) {
        let url = URL(string: "https://raw.githubusercontent.com/hjnilsson/country-flags/master/png100px/\(country.alpha2Code.lowercased()).png")
        self.kf.setImage(with: url, placeholder: nil)
    }
    
    func fullImage(country : Country) {
        let url = URL(string: "https://raw.githubusercontent.com/hjnilsson/country-flags/master/png250px/\(country.alpha2Code.lowercased()).png")
        self.kf.setImage(with: url, placeholder: nil)
    }
}
