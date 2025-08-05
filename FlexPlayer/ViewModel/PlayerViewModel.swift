//
//  PlayerViewModel.swift
//  FlexPlayer
//
//  Created by admin25 on 06/08/25.
//
import Foundation
import Combine

class PlayerViewModel: ObservableObject {
    
    @Published var songTitle: String = "Not Playing"
    @Published var artistName: String = "Select a song"
    @Published var albumArtURL: URL?
    @Published var isPlaying: Bool = false
    @Published var progress: Double = 0.0
    @Published var currentTimeText: String = "0:00"
    @Published var durationText: String = "0:00"
    @Published var currentSource: MusicSourceType = .local
    @Published var songQueue: [Song] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let playerService = MusicPlayerService.shared
    
    init() {
        playerService.$currentSong
            .sink { [weak self] song in
                self?.songTitle = song?.title ?? "Not Playing"
                self?.artistName = song?.artist ?? "Select a song"
                self?.albumArtURL = song?.albumArtURL
                self?.updateProgress(currentTime: 0, duration: song?.duration ?? 0)
            }
            .store(in: &cancellables)
        
        playerService.$playbackState
            .sink { [weak self] state in
                self?.isPlaying = (state == .playing)
            }
            .store(in: &cancellables)
            
        playerService.$currentTime
            .sink { [weak self] time in
                let duration = self?.playerService.currentSong?.duration ?? 0
                self?.updateProgress(currentTime: time, duration: duration)
            }
            .store(in: &cancellables)
            
        playerService.$queue
            .assign(to: \.songQueue, on: self)
            .store(in: &cancellables)
    }
    
    private func updateProgress(currentTime: TimeInterval, duration: TimeInterval) {
        self.currentTimeText = formatTime(currentTime)
        self.durationText = formatTime(duration)
        self.progress = duration > 0 ? (currentTime / duration) : 0.0
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func selectSource(_ source: MusicSourceType) {
        switch source {
        case .local:
            playerService.setSource(strategy: LocalFileSourceStrategy())
        case .spotify:
            playerService.setSource(strategy: SpotifyMockSourceStrategy())
        }
        self.currentSource = source
    }
    
    func playPauseTapped() {
        if isPlaying {
            playerService.pause()
        } else {
            if playerService.playbackState == .paused {
                playerService.resume()
            } else if let firstSong = songQueue.first {
                playerService.play(song: firstSong)
            }
        }
    }
    
    func playSong(_ song: Song) {
        playerService.play(song: song)
    }
    
    func skipNextTapped() {
        playerService.skipToNext()
    }
    
    func skipPreviousTapped() {
        playerService.skipToPrevious()
    }

    func deleteSong(at offsets: IndexSet) {
        playerService.removeFromQueue(at: offsets)
    }

    func moveSong(from source: IndexSet, to destination: Int) {
        playerService.reorderQueue(from: source, to: destination)
    }
}
