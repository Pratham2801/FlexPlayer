import Foundation

enum MusicSourceType: String
{
    case local = "Local Files"
    case spotify = "Spotify"
}

struct Song: Identifiable, Equatable
{
    let id: UUID
    let title: String
    let artist: String
    let duration: TimeInterval
    let albumArtURL: URL?
    let source: MusicSourceType
    let audioFileName: String?

    static var empty: Song
    {
        Song(id: UUID(),
             title: "Not Playing",
             artist: "Select a song",
             duration: 0,
             albumArtURL: nil,
             source: .local,
             audioFileName: nil)
    }
}
