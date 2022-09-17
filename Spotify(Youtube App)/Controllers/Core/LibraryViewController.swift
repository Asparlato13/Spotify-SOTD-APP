//
//  LibraryViewController.swift
//  Spotify(Youtube App)
//
//  Created by Adrianna Parlato on 8/16/22.
//

import UIKit

class LibraryViewController: UIViewController {

    
    private let playlistVC = LibraryPlaylistViewController()
    private let albumVC = LibraryAlbumViewController()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let toggleView = LibraryToggleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(toggleView)
        
        //receive the calls
        toggleView.delegate = self
        
        scrollView.delegate = self
        view.addSubview(scrollView)
        //scrollView.backgroundColor = .yellow
        //to see scroll happen between two pages in libary
        scrollView.contentSize = CGSize(width: view.width*2, height: scrollView.height)
        addChildren()
        updateBarButtons()

        
    }
    //horizontally swipe between two different pages
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0,
                                  y: view.safeAreaInsets.top+55,
                                  width: view.width,
                                  height: view.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-55)
        toggleView.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: 200, height: 55)
    }
    //button to add / create a new playlist
    private func updateBarButtons() {
        switch toggleView.state {
            //in playlist page show add playlist button
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
            //in album page DO NOT show add playlist button
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
        
    }
    
    //if user taps add playlist
    @objc private func didTapAdd() {
        playlistVC.showCreatePlaylistAlert()
    }
    
    
    private func addChildren() {
        //allows all view life cycles functions-- viewdidload viewdidappear etc--- to load approrately on the playlist controller
        addChild(playlistVC)
        scrollView.addSubview(playlistVC.view)
        playlistVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playlistVC.didMove(toParent: self)
        
        
        addChild(albumVC)
        scrollView.addSubview(albumVC.view)
        albumVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumVC.didMove(toParent: self)
    }
}


extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //as user manually scrolls grreen lin under albums and playlist will adjust accordingly
        if scrollView.contentOffset.x >= (view.width-100) {
            toggleView.update(for: .album)
            updateBarButtons()
        }
        else {
            toggleView.update(for: .playlist)
            updateBarButtons()
        }
    }
}


extension LibraryViewController: LibraryToggleViewDelegate {
    func LibraryToggleViewDidTapPlaylist(_ toggleView: LibraryToggleView) {
        //implement th e conncection of scrolling to proper page when user clicks
        scrollView.setContentOffset(.zero, animated: true)
        updateBarButtons()
    }
    func LibraryToggleViewDidTapAlbum(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
        updateBarButtons()
    }
}
