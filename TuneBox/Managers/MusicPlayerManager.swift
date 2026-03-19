import AVFoundation
import MediaPlayer
import Combine

@MainActor
class MusicPlayerManager: NSObject, ObservableObject {
    @Published var currentSong: Song? = nil
    @Published var isPlaying: Bool = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var shuffleEnabled: Bool = false
    @Published var repeatMode: RepeatMode = .none
    @Published var queue: [Song] = []
    @Published var queueIndex: Int = 0

    private var player: AVAudioPlayer?
    private var timer: Timer?

    override init() {
        super.init()
        configureAudioSession()
        setupRemoteCommands()
    }

    // MARK: - Playback

    func play(song: Song, in newQueue: [Song]) {
        let index = newQueue.firstIndex(of: song) ?? 0
        queue = shuffleEnabled ? shuffled(newQueue, startingAt: index) : newQueue
        queueIndex = shuffleEnabled ? 0 : index
        playCurrent()
    }

    func togglePlayPause() {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
            isPlaying = false
            stopTimer()
        } else {
            player.play()
            isPlaying = true
            startTimer()
        }
        updateNowPlayingInfo()
    }

    func seekTo(_ time: TimeInterval) {
        player?.currentTime = time
        currentTime = time
        updateNowPlayingInfo()
    }

    func skipToNext() {
        switch repeatMode {
        case .one:
            seekTo(0)
            player?.play()
        case .none, .queue:
            if queueIndex + 1 < queue.count {
                queueIndex += 1
                playCurrent()
            } else if repeatMode == .queue {
                queueIndex = 0
                playCurrent()
            } else {
                // End of queue
                isPlaying = false
                stopTimer()
            }
        }
    }

    func skipToPrevious() {
        if currentTime > 3 {
            seekTo(0)
        } else if queueIndex > 0 {
            queueIndex -= 1
            playCurrent()
        } else {
            seekTo(0)
        }
    }

    func toggleShuffle() {
        shuffleEnabled.toggle()
        if shuffleEnabled {
            queue = shuffled(queue, startingAt: queueIndex)
            queueIndex = 0
        }
    }

    func cycleRepeatMode() {
        let all = RepeatMode.allCases
        let currentIndex = all.firstIndex(of: repeatMode) ?? 0
        repeatMode = all[(currentIndex + 1) % all.count]
    }

    // MARK: - Private

    private func playCurrent() {
        guard queueIndex < queue.count else { return }
        let song = queue[queueIndex]
        currentSong = song
        duration = song.duration

        do {
            player = try AVAudioPlayer(contentsOf: song.url)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
            isPlaying = true
            currentTime = 0
            startTimer()
            updateNowPlayingInfo()
        } catch {
            isPlaying = false
        }
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self, let player = self.player else { return }
                self.currentTime = player.currentTime
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func shuffled(_ songs: [Song], startingAt index: Int) -> [Song] {
        guard !songs.isEmpty else { return songs }
        let current = songs[index]
        var rest = songs
        rest.remove(at: index)
        rest.shuffle()
        return [current] + rest
    }

    // MARK: - Audio Session

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Audio session setup failed; playback may not work in background
        }
    }

    // MARK: - Now Playing Info

    private func updateNowPlayingInfo() {
        guard let song = currentSong else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }

        var info: [String: Any] = [
            MPMediaItemPropertyTitle: song.title,
            MPMediaItemPropertyArtist: song.artist,
            MPMediaItemPropertyAlbumTitle: song.albumTitle,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: currentTime,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0
        ]

        if let artwork = song.artwork {
            info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: artwork.size) { _ in artwork }
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    // MARK: - Remote Commands

    private func setupRemoteCommands() {
        let center = MPRemoteCommandCenter.shared()

        center.playCommand.addTarget { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self, !self.isPlaying else { return }
                self.togglePlayPause()
            }
            return .success
        }

        center.pauseCommand.addTarget { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self, self.isPlaying else { return }
                self.togglePlayPause()
            }
            return .success
        }

        center.nextTrackCommand.addTarget { [weak self] _ in
            Task { @MainActor [weak self] in self?.skipToNext() }
            return .success
        }

        center.previousTrackCommand.addTarget { [weak self] _ in
            Task { @MainActor [weak self] in self?.skipToPrevious() }
            return .success
        }

        center.changePlaybackPositionCommand.addTarget { [weak self] event in
            if let e = event as? MPChangePlaybackPositionCommandEvent {
                Task { @MainActor [weak self] in self?.seekTo(e.positionTime) }
            }
            return .success
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension MusicPlayerManager: AVAudioPlayerDelegate {
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in
            self.skipToNext()
        }
    }
}
