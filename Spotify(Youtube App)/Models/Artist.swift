//
//  Artist.swift
//  Spotify(Youtube App)
//
//  Created by Adrianna Parlato on 8/16/22.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}
