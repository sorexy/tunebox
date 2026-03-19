import SwiftUI

enum LibrarySegment: Int, CaseIterable {
    case songs, albums, artists

    var title: String {
        switch self {
        case .songs:   return "Songs"
        case .albums:  return "Albums"
        case .artists: return "Artists"
        }
    }
}

struct LibraryTabView: View {
    @EnvironmentObject var library: LibraryManager
    @State private var selectedSegment: LibrarySegment = .songs

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Segmented picker
                Picker("Library", selection: $selectedSegment) {
                    ForEach(LibrarySegment.allCases, id: \.self) { segment in
                        Text(segment.title).tag(segment)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)

                Divider()

                // Content
                TabView(selection: $selectedSegment) {
                    SongsListView()
                        .tag(LibrarySegment.songs)
                    AlbumsGridView()
                        .tag(LibrarySegment.albums)
                    ArtistsListView()
                        .tag(LibrarySegment.artists)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.2), value: selectedSegment)
            }
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await library.scanLibrary() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
}

#Preview {
    LibraryTabView()
        .environmentObject(LibraryManager())
        .environmentObject(MusicPlayerManager())
}
