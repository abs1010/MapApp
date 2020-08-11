//
//  File.swift
//  MapApp
//
//  Created by Alan Silva on 10/08/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

enum ServiceError: String, Error {
    case cannotGetResponse = "No response from server or endpoint."
    case cannotDecodeObject = "Cannot decode returned object. Serialization error."
    case unknow = "Unknow error."
}

class NetWorkService {
    
    static let shared = NetWorkService()
    
    private let baseURL = "https://api.yelp.com/v3/businesses/search?"
    private let apiKey = ""
    
    func getPlacesNearMe(for coordinates: Coordinates, completion: @escaping (Result<Places,ServiceError>) -> Void) {
        
        guard let url = URL(string: baseURL) else { return }
        
        //let dataTask = URLData
        
    }
    
}
