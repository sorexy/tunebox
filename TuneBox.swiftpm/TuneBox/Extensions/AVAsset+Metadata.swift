import AVFoundation
import UIKit

struct SongMetadata {
    var title: String
    var artist: String
    var albumTitle: String
    var albumArtist: String
    var trackNumber: Int?
    var discNumber: Int?
    var duration: TimeInterval
    var artwork: UIImage?
}

extension AVURLAsset {
    func extractMetadata(fallbackTitle: String) async -> SongMetadata {
        var title = fallbackTitle
        var artist = "Unknown Artist"
        var albumTitle = "Unknown Album"
        var albumArtist = ""
        var trackNumber: Int? = nil
        var discNumber: Int? = nil
        var artwork: UIImage? = nil

        let metadata = try? await load(.commonMetadata)
        let duration = (try? await load(.duration).seconds) ?? 0

        for item in metadata ?? [] {
            guard let key = item.commonKey else { continue }
            switch key {
            case .commonKeyTitle:
                if let value = try? await item.load(.stringValue), !value.isEmpty {
                    title = value
                }
            case .commonKeyArtist:
                if let value = try? await item.load(.stringValue), !value.isEmpty {
                    artist = value
                }
            case .commonKeyAlbumName:
                if let value = try? await item.load(.stringValue), !value.isEmpty {
                    albumTitle = value
                }
            case .commonKeyArtwork:
                if let data = try? await item.load(.dataValue),
                   let image = UIImage(data: data) {
                    artwork = image
                }
            default:
                break
            }
        }

        // Try ID3/iTunes formats for track number, disc number, album artist
        let formats: [AVMetadataFormat] = [.id3Metadata, .iTunesMetadata]
        for format in formats {
            guard let formatMetadata = try? await load(.metadata(for: format)) else { continue }
            for item in formatMetadata {
                let keyString = item.identifier?.rawValue ?? ""

                // Album artist
                if keyString.contains("TPE2") || keyString.contains("aART") {
                    if let value = try? await item.load(.stringValue), !value.isEmpty {
                        albumArtist = value
                    }
                }
                // Track number
                if (keyString.contains("TRCK") || keyString.contains("trkn")) && trackNumber == nil {
                    if let value = try? await item.load(.stringValue) {
                        trackNumber = Int(value.components(separatedBy: "/").first ?? "")
                    } else if let value = try? await item.load(.numberValue) {
                        trackNumber = value.intValue
                    }
                }
                // Disc number
                if (keyString.contains("TPOS") || keyString.contains("disk")) && discNumber == nil {
                    if let value = try? await item.load(.stringValue) {
                        discNumber = Int(value.components(separatedBy: "/").first ?? "")
                    } else if let value = try? await item.load(.numberValue) {
                        discNumber = value.intValue
                    }
                }
            }
        }

        if albumArtist.isEmpty {
            albumArtist = artist
        }

        return SongMetadata(
            title: title,
            artist: artist,
            albumTitle: albumTitle,
            albumArtist: albumArtist,
            trackNumber: trackNumber,
            discNumber: discNumber,
            duration: duration,
            artwork: artwork
        )
    }
}
