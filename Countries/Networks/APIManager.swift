//
//  APIManager.swift
//  Countries
//
//  Created by Vineet Kumar on 2/6/19.
//  Copyright © 2019 Scorpion. All rights reserved.
//

import Foundation
import Siesta

class APIManager {
    
    static let `default` = APIManager()
    
    private let service : Service
    
    
    private lazy var url : URL? = {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("data.json") else {
            return nil
        }
        return url
    }()
    
    private lazy var savedItems : [Country] = {
        guard let path = self.url, let data = try? Data(contentsOf: path) else {
            return [];
        }
        return (try? JSONDecoder().decode([Country].self, from: data)) ?? []
    }()
    
    
    var savedCountry : [Country] {
        return self.savedItems
    }
    
    func add(country: Country) {
        
        guard self.savedItems.filter({ $0.alpha3Code == country.alpha3Code}).count == 0 else {
            return
        }
        
        self.savedItems.append(country)
        guard let path = self.url else {
            return
        }
        do{
            let data = try JSONEncoder().encode(self.savedItems)
            try data.write(to: path)
        }
        catch {
            print(error)
        }
    }
    
    init() {
        self.service = Service(baseURL: "https://restcountries.eu/rest/v2/", standardTransformers: [.text, .image])
        #if DEBUG
        // Bare-bones logging of which network calls Siesta makes:
        SiestaLog.Category.enabled = [.network]
        
        // For more info about how Siesta decides whether to make a network call,
        // and which state updates it broadcasts to the app:
        //SiestaLog.Category.enabled = .common
        // For the gory details of what Siesta’s up to:
        //SiestaLog.Category.enabled = .detailed
        // To dump all requests and responses:
        // (Warning: may cause Xcode console overheating)
        //SiestaLog.Category.enabled = .all
        #endif
        
        // –––––– Global configuration ––––––
        let jsonDecoder = JSONDecoder()
        
        self.service.configure {
            // Custom transformers can change any response into any other — including errors.
            // Here we replace the default error message with the one provided by the  API (if present).
            $0.pipeline[.cleanup].add(
                ErrorMessageExtractor(jsonDecoder: jsonDecoder))
        }
        
        // –––––– Resource-specific configuration ––––––
        self.service.configure("/name/**") {
            // Refresh search results after 10 seconds (Siesta default is 30)
            $0.expirationTime = 5
        }
        
        
        // –––––– Mapping from specific paths to models ––––––
        self.service.configureTransformer("/name/*") {
            try jsonDecoder.decode([Country].self, from: $0.content)
        }
    }
    
    func country(_ text: String) -> Resource {
        return self.service
            .resource("/name")
            .child(text.lowercased())
    }
}



// MARK: - Custom transformers

/// If the response is JSON and has a "message" value, use it as the user-visible error message.
private struct ErrorMessageExtractor: ResponseTransformer {
    let jsonDecoder: JSONDecoder
    
    func process(_ response: Response) -> Response {
        guard case .failure(var error) = response,     // Unless the response is a failure...
            let errorData: Data = error.typedContent(),  // ...with data...
            let errorEnvelope = try? jsonDecoder.decode(   // ...that encodes a standard GitHub error envelope...
                ErrorEnvelope.self, from: errorData)
            else {
                return response                              // ...just leave it untouched.
        }
        
        error.userMessage = errorEnvelope.message        //  Provided an error message. Show it to the user!
        return .failure(error)
    }
    
    private struct ErrorEnvelope: Decodable {
        let message: String
    }
}
