//
//  MusicPlayerService.swift
//  FlexPlayer
//
//  Created by admin25 on 06/08/25.
//
import Foundation
import Combine


class MusicPlayerService: ObservableObject
{

    
    static let shared = MusicPlayerService()

  
    @Published private(set) var currentSong: Song?
    @Published private(set) var playbackState: PlaybackState = .stopped
    @Published private(set) var queue: [Song] = []
    @Published private(set) var currentTime: TimeInterval = 0

    // Internal properties
    private var currentQueueIndex: Int?
    private var musicSourceStrategy: MusicSourceStrategy?
    private var progressTimer: AnyCancellable?



    func setSource(strategy: MusicSourceStrategy) {
        self.musicSourceStrategy = strategy
        self.stop() // Stop current playback
        self.queue = [] // Clear the queue

        musicSourceStrategy?.loadSongs { [weak self] songs in
            self?.queue = songs
        }
    }


    func play(song: Song) {
        
        if song.id == currentSong?.id {
            resume()
            return
        }

       
        if let index = queue.firstIndex(where: { $0.id == song.id }) {
            currentQueueIndex = index
            currentSong = song
            startPlayback()
        }
    }

    func pause() {
        guard playbackState == .playing else { return }
        playbackState = .paused
        stopProgressTimer()
    }

    func resume() {
        guard playbackState == .paused else { return }
        startPlayback()
    }

    func stop() {
        currentSong = nil
        currentQueueIndex = nil
        playbackState = .stopped
        currentTime = 0
        stopProgressTimer()
    }

    func skipToNext() {
        guard let currentIndex = currentQueueIndex, !queue.isEmpty else { return }

        let nextIndex = (currentIndex + 1) % queue.count
        play(song: queue[nextIndex])
    }

    func skipToPrevious() {
        guard let currentIndex = currentQueueIndex, !queue.isEmpty else { return }

       
        if currentTime > 3 {
            currentTime = 0
            startPlayback()
            return
        }

        
        let prevIndex = (currentIndex - 1 + queue.count) % queue.count
        play(song: queue[prevIndex])
    }


    func addToQueue(songs: [Song]) {
        self.queue.append(contentsOf: songs)
    }

    func removeFromQueue(at indexSet: IndexSet) {
        self.queue.remove(atOffsets: indexSet)
    }

    func reorderQueue(from source: IndexSet, to destination: Int) {
        self.queue.move(fromOffsets: source, toOffset: destination)
    }

    // MARK: - Private Helper Methods

    private func startPlayback() {
        playbackState = .playing
        
        startProgressTimer()
    }

    private func startProgressTimer() {
        stopProgressTimer()
        progressTimer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, self.playbackState == .playing else { return }

                self.currentTime += 1.0

                if self.currentTime >= self.currentSong?.duration ?? 0 {
                    self.skipToNext()
                }
            }
    }

    private func stopProgressTimer() {
        progressTimer?.cancel()
    }
    
}
