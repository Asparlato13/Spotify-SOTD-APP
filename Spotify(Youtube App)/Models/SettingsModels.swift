//
//  SettingsModels.swift
//  Spotify(Youtube App)
//
//  Created by Adrianna Parlato on 8/18/22.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
    
}

struct Option {
    let title: String
    let handler: () -> Void
    
}
