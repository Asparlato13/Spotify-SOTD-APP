//
//  AlbumViewController.swift
//  Spotify(Youtube App)
//
//  Created by Adrianna Parlato on 9/5/22.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        //item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
                                              )
            )
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
            ),
            subitem: item,
            count: 1)
        
        //section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalWidth(1)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)]
            
            return section
    }))


    private var viewModels = [AlbumCollectionViewCellViewModel]()
    
    private var tracks = [AudioTrack]()

    private let album: Album
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(AlbumTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
        collectionView.register(PlaylistHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self


        APICaller.shared.getAlbumDetails(for: album) { [weak self] result in
            DispatchQueue.main.sync {
                switch result {
                    //fetch tracks in actual album
                case .success(let model):
                    self?.tracks = model.tracks.items
                    self?.viewModels = model.tracks.items.compactMap({
                        AlbumCollectionViewCellViewModel(
                        name: $0.name,
                        artistName: $0.artists.first?.name ?? "-"
                        
                        )
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    //    break
                    print(error.localizedDescription)
                }
            }
        }
    }
     
                
          override func viewDidLayoutSubviews() {
              super.viewDidLayoutSubviews()
              collectionView.frame = view.bounds
          }
      }

      extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
          func numberOfSections(in collectionView: UICollectionView) -> Int {
              return 1
          }
          func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
              return viewModels.count
            
          }
          func collectionView(_ collectionView: UICollectionView, cellForItemAt IndexPath: IndexPath) -> UICollectionViewCell {
              guard let cell = collectionView.dequeueReusableCell(
                  withReuseIdentifier: AlbumTrackCollectionViewCell.identifier,
                  for: IndexPath)
              as? AlbumTrackCollectionViewCell else {
                  return UICollectionViewCell()
              }
             // cell.backgroundColor = .red
              cell.confgure(with: viewModels[IndexPath.row])
              return cell
          }
          
          
          func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
              guard let header = collectionView.dequeueReusableSupplementaryView(
                  ofKind: kind,
                  withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
                  for: indexPath)
                  as? PlaylistHeaderCollectionReusableView,
                 kind == UICollectionView.elementKindSectionHeader else {
                  return UICollectionReusableView()
              }
              let headerViewModel = PlaylistHeaderViewViewModel(
                  name: album.name,
                  ownerName: album.artists.first?.name,
                  description: "Release Date: \(album.release_date)",
                  artworkURL: URL(string: album.images.first?.url ?? "")
                  )
              
              //when date extension works!!
              //description: "Release Date: \(String.formattedDate(string: album.release_date))",
   

              header.configure(with: headerViewModel)
              header.delegate = self
              return header
          }

          //tap on item and play song

          func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
              collectionView.deselectItem(at: indexPath, animated: true)
              //play song
              //when user taps on rows
              let track = tracks[indexPath.row]
              PlaybackPresenter.startPlayback(from: self, track: track)
          }
          
      }


extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        //start play list in  queue
        PlaybackPresenter.startPlayback(from: self, tracks: tracks)
    }

              
}

        
        
        
    

 


