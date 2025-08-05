//
//  AudioDBAlbum.swift
//  FlexPlayer
//
//  Created by admin25 on 06/08/25.
//
import Foundation
struct AudioDBAlbumResponse: Codable {
    let album: [AudioDBAlbum]
}

// Matches a single album from the API
struct AudioDBAlbum: Codable {
    let idAlbum: String
    let strAlbum: String
    let strArtist: String
    let strAlbumThumb: String?
    let intYearReleased: String?
    
    var albumArtURL: URL? {
        if var urlString = strAlbumThumb {
            urlString.append("/preview")
            return URL(string: urlString)
        }
        return nil
    }
}
