//
//  PlaylistDetailResponse.swift
//  Spotify(Youtube App)
//
//  Created by Adrianna Parlato on 9/6/22.
//

import Foundation

struct PlaylistDetailResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let tracks: PlaylistTracksResponse
   
}

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let track: AudioTrack
}
