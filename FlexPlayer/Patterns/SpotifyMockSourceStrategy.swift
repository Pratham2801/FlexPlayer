//
//  SpotifyMockSourceStrategy.swift
//  FlexPlayer
//
//  Created by admin25 on 06/08/25.
//
import Foundation

struct SpotifyMockSourceStrategy: MusicSourceStrategy {
    var type: MusicSourceType = .spotify
    
    private let artistIDToFetch = "111239"

    func loadSongs(completion: @escaping ([Song]) -> Void) {
        
        let urlString = "https://www.theaudiodb.com/api/v1/json/2/album.php?i=\(artistIDToFetch)"

        NetworkManager.shared.fetch(from: urlString) { (result: Result<AudioDBAlbumResponse, NetworkError>) in

            switch result {
            case .success(let response):
                let songs = response.album.map { album -> Song in
                    return Song(
                        id: UUID(),
                        title: album.strAlbum,
                        artist: album.strArtist,
                        duration: 180,
                        albumArtURL: album.albumArtURL,
                        source: .spotify,
                        audioFileName: nil
                    )
                }
                
                completion(songs)

            case .failure(let error):
                print("Failed to fetch albums from TheAudioDB: \(error)")
                completion([])
            }
        }
    }
}
