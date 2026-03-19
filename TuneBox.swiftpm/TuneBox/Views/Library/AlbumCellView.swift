import SwiftUI

struct AlbumCellView: View {
    let album: Album

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ArtworkImageView(image: album.artwork, cornerRadius: 8)
                .aspectRatio(1, contentMode: .fit)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)

            Text(album.title)
                .font(.albumTitle)
                .foregroundColor(.tuneBoxPrimary)
                .lineLimit(2)

            Text(album.albumArtist)
                .font(.albumArtist)
                .foregroundColor(.tuneBoxSecondary)
                .lineLimit(1)
        }
    }
}
