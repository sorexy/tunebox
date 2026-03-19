import SwiftUI

struct MiniPlayerView: View {
    @EnvironmentObject var player: MusicPlayerManager
    @Binding var showingNowPlaying: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Thin progress bar at top
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                    Rectangle()
                        .fill(Color.tuneBoxAccent)
                        .frame(width: player.duration > 0
                               ? geo.size.width * CGFloat(player.currentTime / player.duration)
                               : 0)
                }
            }
            .frame(height: 2)

            // Main content
            HStack(spacing: 12) {
                ArtworkImageView(
                    image: player.currentSong?.artwork,
                    size: 44,
                    cornerRadius: 4
                )

                VStack(alignment: .leading, spacing: 1) {
                    Text(player.currentSong?.title ?? "")
                        .font(.miniPlayerTitle)
                        .foregroundColor(.tuneBoxPrimary)
                        .lineLimit(1)
                    Text(player.currentSong?.artist ?? "")
                        .font(.miniPlayerArtist)
                        .foregroundColor(.tuneBoxSecondary)
                        .lineLimit(1)
                }

                Spacer()

                Button {
                    player.togglePlayPause()
                } label: {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.tuneBoxPrimary)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }

                Button {
                    player.skipToNext()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.tuneBoxPrimary)
                        .frame(width: 36, height: 44)
                        .contentShape(Rectangle())
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 64)
        }
        .background(BlurredBackgroundView(style: .systemChromeMaterial))
        .onTapGesture {
            showingNowPlaying = true
        }
    }
}
