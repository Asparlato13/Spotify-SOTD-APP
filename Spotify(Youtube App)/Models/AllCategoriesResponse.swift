//
//  AllCategoriesResponse.swift
//  Spotify(Youtube App)
//
//  Created by Adrianna Parlato on 9/12/22.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
    
}
struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
    
}


