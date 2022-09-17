//
//  LibraryPlaylistViewController.swift
//  Spotify(Youtube App)
//
//  Created by Adrianna Parlato on 9/16/22.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {
    
    var playlists = [Playlist]()
    
    private let noPlaylistsView = ActionLabelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(noPlaylistsView)
        setUpNoPlaylistsView()
        fetchData()
    }

    private func setUpNoPlaylistsView() {
        view.addSubview(noPlaylistsView)
        noPlaylistsView.delegate = self
        //if user doesn't have playlists
        noPlaylistsView.configure(with: ActionLabelViewViewModel(text: "You don't have any playlists yet", actionTitle: "Create"))
    }
    
    
    private func fetchData() {
        //call api
        APICaller.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
         
            
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistsView.center = view.center
    }
    private func updateUI() {
        if playlists.isEmpty {
            //show label-- create new playlist
            noPlaylistsView.isHidden = false
        }
        else {
            //show tabel
        }
        
    
    }
    
}


extension LibraryPlaylistViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        //show creation Ui for playlist
    }
    
    
}
