import SwiftUI

struct AlbumsGridView: View {
    @EnvironmentObject var library: LibraryManager

    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        Group {
            if library.isScanning {
                ProgressView("Loading library…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if library.albums.isEmpty {
                EmptyLibraryView()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(library.albums) { album in
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
                .refreshable {
                    await library.scanLibrary()
                }
            }
        }
    }
}
