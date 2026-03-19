import SwiftUI

struct NowPlayingView: View {
    @EnvironmentObject var player: MusicPlayerManager
    @Environment(\.dismiss) private var dismiss

    @State private var isPresented = true

    var body: some View {
        VStack(spacing: 0) {
            NowPlayingHeaderView(isPresented: $isPresented)
                .onChange(of: isPresented) { newValue in
                    if !newValue { dismiss() }
                }

            ScrollView {
                VStack(spacing: 0) {
                    // Artwork
                    ArtworkView(
                        image: player.currentSong?.artwork,
                        isPlaying: player.isPlaying
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 28)

                    // Song info
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(player.currentSong?.title ?? "")
                                .font(.nowPlayingTitle)
                                .foregroundColor(.tuneBoxPrimary)
                                .lineLimit(1)

                            Text(player.currentSong?.artist ?? "")
                                .font(.nowPlayingArtist)
                                .foregroundColor(.tuneBoxAccent)
                                .lineLimit(1)
                        }

                        Spacer()

                        Button {
                            // Future: show options menu
                        } label: {
                            Image(systemName: "ellipsis.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.tuneBoxSecondary, Color(.systemGray5))
                        }
                    }
                    .padding(.horizontal, 24)

                    // Progress bar
                    ProgressBarView(
                        currentTime: $player.currentTime,
                        duration: player.duration,
                        onSeek: { player.seekTo($0) }
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 20)

                    // Transport controls
                    TransportControlsView()
                        .padding(.horizontal, 24)
                        .padding(.top, 28)

                    // Volume
                    VolumeControlView()
                        .padding(.horizontal, 24)
                        .padding(.top, 24)

                    // Bottom padding
                    Spacer(minLength: 40)
                }
            }
        }
        .background(Color.tuneBoxBackground)
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden) // we draw our own
    }
}

#Preview {
    NowPlayingView()
        .environmentObject(MusicPlayerManager())
}
