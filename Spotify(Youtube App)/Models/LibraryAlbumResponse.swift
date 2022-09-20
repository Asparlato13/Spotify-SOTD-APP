//
//  LibraryAlbumResponse.swift
//  Spotify(Youtube App)
//
//  Created by Adrianna Parlato on 9/20/22.
//

import Foundation


struct LibraryAlbumResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let album: Album
    let added_at: String
}
