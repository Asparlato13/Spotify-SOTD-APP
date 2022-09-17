//
//  APICaller.swift
//  Spotify(Youtube App)
//
//  Created by Adrianna Parlato on 8/16/22.
//

import Foundation


final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
        
    }
    
    
    //MARK: Albums
    public func getAlbumDetails(for album: Album, completion:  @escaping (Result<AlbumDetailResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
            type: .GET){
                request in
                let task = URLSession.shared.dataTask(with: request){ data, _,  error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(AlbumDetailResponse.self, from: data)
                        // let json = try JSONSerialization.jsonObject(with: data,
                        //         options: .allowFragments)
                        //print(result)
                        completion(.success(result))
                    }
                    catch {
                        print(error)
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
        
    }
    
    
    //MARK: playlsts
    public func getPlaylistDetails(for playlist: Playlist, completion:  @escaping (Result<PlaylistDetailResponse, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
            type: .GET){
                request in
                let task = URLSession.shared.dataTask(with: request){ data, _,  error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(PlaylistDetailResponse.self, from: data)
                        //  let json = try JSONSerialization.jsonObject(with: data,
                        //     options: .allowFragments)
                        //    print(result)
                        completion(.success(result))
                        //   print(json)
                    }
                    catch {
                        // print(error)
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
        
    }
    
    
    public func getCurrentUserPlaylists(completion: @escaping (Result<[Playlist], Error>) -> Void ) {
        //writing out the api
        createRequest(with: URL(string: Constants.baseAPIURL + "/me/playlists/?limit=50"),
                      type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(LibraryPlaylistResponse.self, from: data)
                    completion(.success(result.items))
                    //json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //print(json)
                    
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
        
    }
    public func createPlaylists(
        with name: String,
        completion: @escaping (Bool) -> Void ) {
        
    }
    public func addTrackPlaylists(
        track: AudioTrack,
        playlist: Playlist,
        completion: @escaping (Bool) -> Void
    ) {
        
    }
    public func removeTrackFromPlaylists(  track: AudioTrack,
                                           playlist: Playlist,
                                           completion: @escaping (Bool) -> Void) {
        
    }
    
    
    
    
    
    //MARK: profile
    
    public func getCurrentUserProfile(completion:  @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me"),
            type: .GET) { baseRequest in
                let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(UserProfile.self, from: data)
                        completion(.success(result))
                    }
                    catch {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
                
                task.resume()
            }
        
    }
    
    
    //MARK: Browse
    
    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponses, Error>))-> Void) {
        //(completion: @escaping ((Result<String, Error>))-> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL  + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let  data = data, error  == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponses.self, from: data)
                    //JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    // print(result)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    //public  func getFeaturedPlaylists(completion: @escaping ((Result<string, Error>) -> Void)){
    public func getFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistResponse, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL  + "/browse/featured-playlists?limit=20"), type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let  data = data, error  == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    //let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    // print(json)
                    let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                    // print(result)
                    completion(.success(result))
                    
                }
                catch {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    //three } here runs -- two does not
    //     }
    // }
    //   }
    
    //public func getRecommendations(completion: @escaping ((Result<String, Error>)) -> Void) {
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationResponse, Error>) -> Void)) {
        let seeds =  genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=40&seed_genres=\(seeds)"), type: .GET) {
            request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _,  error in
                guard let  data = data, error  == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    // let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    // print("json: \(result)")
                    
                    let result = try JSONDecoder().decode(RecommendationResponse.self, from: data)
                    // print(result)
                    completion(.success(result))
                    
                    
                    
                }
                catch {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenresResponse, Error>) -> Void)) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET) {
            request in
            let task = URLSession.shared.dataTask(with: request) { data, _,  error in
                guard let  data = data, error  == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //  print("json: \(result)")
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    //print(result)
                    completion(.success(result))
                    
                }
                catch {
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    // MARK: - Category
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=50"),
                      type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) {
                data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                    //  let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    //   print(json)
                    completion(.success(result.categories.items))
                    //    print(result.categories.items)
                }
                catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    
    public func getCategoryPlaylist(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=50"),
                      type: .GET)
        { request in
            let task = URLSession.shared.dataTask(with: request) {
                data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    
                    let result = try JSONDecoder().decode(CategoryPlaylistResponse.self, from: data)
                    let playlists = result.playlists.items
                    //  print(playlists)
                    completion(.success(playlists))
                    // let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    // print(json)
                }
                catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    }
    
    
    
    // MARK: - search
    
    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL+"/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
                      type: .GET)
        { request in
            print(request.url?.absoluteString ?? "none")
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                   
                    return
                }
                do {
                    let result = try JSONDecoder().decode(SearchResultsResponse.self, from: data)
        //one type the enecapsulates alll search results
                    var searchResults: [SearchResult] = []
                    
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ .track(model: $0) }))
                    searchResults.append(contentsOf: result.albums.items.compactMap({ .album(model: $0) }))
                    searchResults.append(contentsOf: result.artists.items.compactMap({ .artists(model: $0) }))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({ .playlist(model: $0) }))
                    completion(.success(searchResults))
          
                   // completion(.success(result))
                    // let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                  //  print(json)
                }
                catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    
    
    // MARK: - private
    
    
    enum HTTPMethod: String {
        case GET
        case POST
        
    }
    
    private func createRequest(
        with url: URL?, type: HTTPMethod,
        completion: @escaping (URLRequest) -> Void) {
            AuthManager.shared.withValidToken{ token in
                guard let apiurl = url else {
                    return
                }
                var request = URLRequest(url: apiurl)
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.httpMethod = type.rawValue
                request.timeoutInterval = 30
                completion(request)
            }
        }
    
    
}
