//
//  File.swift
//  MapApp
//
//  Created by Alan Silva on 10/08/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

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
    
    private let baseURL = "https://api.yelp.com/v3/businesses/search"
    private let apiKey = "Bearer lZX3G1KKAHmQl7dMqexnxTRNkS4v_OA4hvGiQ70ZQm14oUg6qkHfjSFcNBjT-zxUc_J4P4Q42aWd_lExbQKjFFQ-CmEREGPGD5wRtMOaP8UEBvLkSmOAtL74XKQxX3Yx"
    
    func getPlacesNearMe(for coordinates: Coordinates, completion: @escaping (Result<Places,ServiceError>) -> Void) {
        
        guard let url = URL(string: baseURL) else { fatalError() }
        
        let header: HTTPHeaders = ["Authorization": apiKey]
        
        let parameters: [String:Any] =
            ["latitude": coordinates.latitude,
             "longitude": coordinates.longitude,
             "limit": 50,
             "offset": 0,
             "locale": "pt_BR",
             "categories": "restaurant"]
        
        AF.request(url, method: .get, parameters: parameters, headers: header).responseJSON { response in
            
            if response.response?.statusCode == 200 {
                
                guard let jsonData = response.data else {
                    completion(.failure(.unknow))
                    return
                }
                
                do {
                    let places = try JSONDecoder().decode(Places.self, from: jsonData)
                    completion(.success(places))
                } catch {
                    completion(.failure(.cannotDecodeObject))
                }
            
            } else {
                completion(.failure(.cannotGetResponse))
            }
            
        }
        
    }
    
}
