//
//  AuthResponse.swift
//  Spotify(Youtube App)
//
//  Created by Adrianna Parlato on 8/17/22.
//

import Foundation

struct AuthResponse: Codable  {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
    
    
    
}

