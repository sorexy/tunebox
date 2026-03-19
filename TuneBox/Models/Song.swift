import UIKit

struct Song: Identifiable, Equatable, Hashable {
    let id: UUID
    let url: URL
    let title: String
    let artist: String
    let albumTitle: String
    let albumArtist: String
    let trackNumber: Int?
    let discNumber: Int?
    let duration: TimeInterval
    let artwork: UIImage?
    let fileSize: Int64

    static func == (lhs: Song, rhs: Song) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
