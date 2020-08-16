//
//  Places.swift
//  MapApp
//
//  Created by Alan Silva on 11/08/20.
//  Copyright © 2020 Alan Silva. All rights reserved.
//

import Foundation

// MARK: - Places
struct Places: Codable {
    let businesses: [Business]?
    let total: Int?
    let region: Region?
}

// MARK: - Business
struct Business: Codable {
    let id, alias, name: String?
    let imageURL: String?
    let isClosed: Bool?
    let url: String?
    let reviewCount: Int?
    let categories: [Category]?
    let rating: Double?
    let coordinates: Coordinates?
    let transactions: [String]?
    let price: String?
    let location: Location?
    let phone, displayPhone: String?
    let distance: Double?

    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageURL = "image_url"
        case isClosed = "is_closed"
        case url
        case reviewCount = "review_count"
        case categories, rating, coordinates, transactions, price, location, phone
        case displayPhone = "display_phone"
        case distance
    }
}

// MARK: - Category
struct Category: Codable {
    let alias, title: String?
}

// MARK: - Location
struct Location: Codable {
    let address1: String?
    let address2, address3: String?
    let city: String?
    let zipCode: String?
    let country: String?
    let state: String?
    let displayAddress: [String]?

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
    }
}

// MARK: - Region
struct Region: Codable {
    let center: Coordinates?
}

struct Coordinates : Codable{
    let latitude: Double?
    let longitude: Double?
}
