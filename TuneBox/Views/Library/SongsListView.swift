import SwiftUI

struct SongsListView: View {
    @EnvironmentObject var library: LibraryManager
    @EnvironmentObject var player: MusicPlayerManager

    var body: some View {
        Group {
            if library.isScanning {
                ProgressView("Loading library…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if library.songs.isEmpty {
                EmptyLibraryView()
            } else {
                List(library.songs) { song in
                    SongRowView(song: song)
                        .onTapGesture {
                            player.play(song: song, in: library.songs)
                        }
                        .listRowBackground(
                            player.currentSong == song
                                ? Color.tuneBoxAccent.opacity(0.08)
                                : Color.clear
                        )
                        .swipeActions(edge: .trailing) {
                            Button {
                                // Add to queue
                            } label: {
                                Label("Add to Queue", systemImage: "text.badge.plus")
                            }
                            .tint(.orange)
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
