//
//  SearchResult.swift
//  Spotify(Youtube App)
//
//  Created by Adrianna Parlato on 9/13/22.
//

import Foundation

enum SearchResult {
    case artists(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}

