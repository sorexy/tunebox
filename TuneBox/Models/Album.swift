import UIKit

struct Album: Identifiable {
    let id: String  // "\(albumTitle)_\(albumArtist)" key
    let title: String
    let albumArtist: String
    let artwork: UIImage?
    var songs: [Song]  // sorted by disc/track
}
