//
//  NewReleaseResponse.swift
//  Spotify(Youtube App)
//
//  Created by Adrianna Parlato on 8/30/22.
//

import Foundation
struct NewReleasesResponses: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}

struct Album: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    var images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
    
}


