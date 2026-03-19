import SwiftUI

struct ArtistsListView: View {
    @EnvironmentObject var library: LibraryManager

    var body: some View {
        Group {
            if library.isScanning {
                ProgressView("Loading library…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if library.artists.isEmpty {
                EmptyLibraryView()
            } else {
                List(library.artists) { artist in
                    NavigationLink(destination: ArtistDetailView(artist: artist)) {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray5))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "person.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.secondary)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(artist.name)
                                    .font(.songTitle)
                                Text("\(artist.albums.count) album\(artist.albums.count == 1 ? "" : "s")")
                                    .font(.songSubtitle)
                                    .foregroundColor(.tuneBoxSecondary)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await library.scanLibrary()
                }
            }
        }
    }
}
