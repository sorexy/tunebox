import SwiftUI

struct ContentView: View {
    @EnvironmentObject var player: MusicPlayerManager
    @State private var showingNowPlaying = false

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                LibraryTabView()
                    .tabItem {
                        Label("Library", systemImage: "music.note.list")
                    }
            }
            .safeAreaInset(edge: .bottom) {
                if player.currentSong != nil {
                    MiniPlayerView(showingNowPlaying: $showingNowPlaying)
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                }
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: player.currentSong != nil)
        .sheet(isPresented: $showingNowPlaying) {
            NowPlayingView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LibraryManager())
        .environmentObject(MusicPlayerManager())
}
