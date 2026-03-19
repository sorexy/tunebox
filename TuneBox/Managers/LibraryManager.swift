import Foundation
import AVFoundation
import UIKit

@MainActor
class LibraryManager: ObservableObject {
    @Published var songs: [Song] = []
    @Published var albums: [Album] = []
    @Published var artists: [Artist] = []
    @Published var isScanning: Bool = false
    @Published var scanError: String? = nil

    private let supportedExtensions = ["mp3", "m4a", "aac", "wav", "aiff", "aifc", "flac"]

    var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func scanLibrary() async {
        isScanning = true
        scanError = nil

        do {
            let urls = try audioFileURLs()
            var loadedSongs: [Song] = []

            await withTaskGroup(of: Song?.self) { group in
                for url in urls {
                    group.addTask {
                        await self.loadSong(from: url)
                    }
                }
                for await song in group {
                    if let song = song {
                        loadedSongs.append(song)
                    }
                }
            }

            loadedSongs.sort { lhs, rhs in
                if lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending { return true }
                return false
            }

            songs = loadedSongs
            albums = groupIntoAlbums(loadedSongs)
            artists = groupIntoArtists(albums)
        } catch {
            scanError = error.localizedDescription
        }

        isScanning = false
    }

    private func audioFileURLs() throws -> [URL] {
        let contents = try FileManager.default.contentsOfDirectory(
            at: documentsURL,
            includingPropertiesForKeys: [.fileSizeKey, .isRegularFileKey],
            options: [.skipsHiddenFiles]
        )
        return contents.filter { url in
            supportedExtensions.contains(url.pathExtension.lowercased())
        }
    }

    private func loadSong(from url: URL) async -> Song? {
        let asset = AVURLAsset(url: url)
        let fallbackTitle = url.deletingPathExtension().lastPathComponent

        let metadata = await asset.extractMetadata(fallbackTitle: fallbackTitle)

        let fileSize = (try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize).map { Int64($0) } ?? 0

        return Song(
            id: UUID(),
            url: url,
            title: metadata.title,
            artist: metadata.artist,
            albumTitle: metadata.albumTitle,
            albumArtist: metadata.albumArtist,
            trackNumber: metadata.trackNumber,
            discNumber: metadata.discNumber,
            duration: metadata.duration,
            artwork: metadata.artwork,
            fileSize: fileSize
        )
    }

    private func groupIntoAlbums(_ songs: [Song]) -> [Album] {
        var albumMap: [String: Album] = [:]

        for song in songs {
            let key = "\(song.albumTitle)_\(song.albumArtist)"
            if albumMap[key] == nil {
                albumMap[key] = Album(
                    id: key,
                    title: song.albumTitle,
                    albumArtist: song.albumArtist,
                    artwork: song.artwork,
                    songs: []
                )
            }
            albumMap[key]?.songs.append(song)
        }

        // Sort songs within each album by disc, then track
        for key in albumMap.keys {
            albumMap[key]?.songs.sort { lhs, rhs in
                let lhsDisc = lhs.discNumber ?? 1
                let rhsDisc = rhs.discNumber ?? 1
                if lhsDisc != rhsDisc { return lhsDisc < rhsDisc }
                let lhsTrack = lhs.trackNumber ?? Int.max
                let rhsTrack = rhs.trackNumber ?? Int.max
                return lhsTrack < rhsTrack
            }
        }

        return albumMap.values.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    private func groupIntoArtists(_ albums: [Album]) -> [Artist] {
        var artistMap: [String: Artist] = [:]

        for album in albums {
            let key = album.albumArtist.lowercased()
            if artistMap[key] == nil {
                artistMap[key] = Artist(id: key, name: album.albumArtist, albums: [])
            }
            artistMap[key]?.albums.append(album)
        }

        for key in artistMap.keys {
            artistMap[key]?.albums.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }

        return artistMap.values.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
