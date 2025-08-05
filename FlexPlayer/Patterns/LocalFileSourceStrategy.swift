import Foundation

struct LocalFileSourceStrategy: MusicSourceStrategy {
    var type: MusicSourceType = .local
    
    func loadSongs(completion: @escaping ([Song]) -> Void) {
        let localSongs = [
            Song(
                id: UUID(),
                title: "Ambient Classical Guitar",
                artist: "William King",
                duration: 132,
                albumArtURL: URL(string: "https://picsum.photos/seed/guitar/400"),
                source: .local,
                audioFileName: "song1"
            ),
            Song(
                id: UUID(),
                title: "The Cradle of Your Soul",
                artist: "lemonmusicstudio",
                duration: 184,
                albumArtURL: URL(string: "https://picsum.photos/seed/soul/400"),
                source: .local,
                audioFileName: "song2"
            )
        ]
        
        completion(localSongs)
    }
}
