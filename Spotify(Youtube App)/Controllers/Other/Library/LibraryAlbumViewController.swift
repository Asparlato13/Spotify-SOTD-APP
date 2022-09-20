//
//  LibraryAlbumViewController.swift
//  Spotify(Youtube App)
//
//  Created by Adrianna Parlato on 9/16/22.
//

import UIKit


//receveing side of album view controller
class LibraryAlbumViewController: UIViewController, UITableViewDataSource {
    
    var albums = [Album]()
    
    
    private let noAlbumsView = ActionLabelView()
    
    //create table vuew
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(noAlbumsView)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
     //   view.backgroundColor = .green
        setUpNoAlbumsView()
        fetchData()
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotificaion,
            object: nil,
            queue: .main,
            using: { _ in
                self.fetchData()
        })
        
        
    }
    //selecor to dismiss adding to playlist
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width: 150, height: 150)
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    private func setUpNoAlbumsView() {
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        noAlbumsView.configure(with: ActionLabelViewViewModel(text: "You don't have any saved albums yet", actionTitle: "Browse"))
    }
    
    
    private func fetchData() {
        //reload table view so it is always up to date with the latest saved albums in library
        albums.removeAll()
        //call api
        APICaller.shared.getCurrentUserAlbums { [weak self] result in
            DispatchQueue.main.async {
            switch result {
            case .success(let albums):
            self?.albums = albums
            self?.updateUI()
            case .failure(let error):
            print(error.localizedDescription)
            }
        
            }
        
        }
    }
 
    private func updateUI() {
        if albums.isEmpty {
            //show label-- create new playlist
           // noAlbumsView.backgroundColor = .red
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        }
        else {
            //show tabel
            tableView.reloadData()
            tableView.isHidden = false
            noAlbumsView.isHidden = true
        }
        
        
    }
}


    extension LibraryAlbumViewController: ActionLabelViewDelegate {
        func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
            //switch user backk to browse tab bc they dot have albums
            tabBarController?.selectedIndex = 0
          
    }
    }

    extension LibraryAlbumViewController:  UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return albums.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
                return UITableViewCell()
            }
            //playlsit at given postion
            let album = albums[indexPath.row]
            cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: album.name, subtitle: album.artists.first?.name ?? "-", imageURL: URL(string: album.images.first?.url ?? "")))
                return cell
        }
        
        //when user clicks album display data within that album
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let album = albums[indexPath.row]
            let vc = AlbumViewController(album: album)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
        
        
        //size of album cell on library
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
        
    }

