//
//  AudioDBModels.swift
//  FlexPlayer
//
//  Created by admin25 on 06/08/25.
//
import Foundation

struct AudioDBResponse: Codable {
    let track: [AudioDBTrack]?
}

struct AudioDBTrack: Codable {
    let idTrack: String
    let strTrack: String?
    let strArtist: String?
    let intDuration: String?
    let strTrackThumb: String?
    
    var durationInSeconds: TimeInterval {
        if let durationStr = intDuration, let durationMS = Double(durationStr) {
            return durationMS / 1000.0
        }
        return 0
    }
    
    var albumArtURL: URL? {
        if var urlString = strTrackThumb {
            urlString.append("/preview")
            return URL(string: urlString)
        }
        return nil
    }
}
