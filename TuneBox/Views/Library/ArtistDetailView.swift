import SwiftUI

struct ArtistDetailView: View {
    let artist: Artist
    @EnvironmentObject var player: MusicPlayerManager

    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(artist.albums) { album in
                    NavigationLink(destination: AlbumDetailView(album: album)) {
                        AlbumCellView(album: album)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .padding(.bottom, 80)
        }
        .navigationTitle(artist.name)
        .navigationBarTitleDisplayMode(.large)
    }
}
