import SwiftUI

struct TransportControlsView: View {
    @EnvironmentObject var player: MusicPlayerManager

    var body: some View {
        HStack(alignment: .center) {
            // Shuffle
            Button {
                player.toggleShuffle()
            } label: {
                Image(systemName: "shuffle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(player.shuffleEnabled ? .tuneBoxAccent : .tuneBoxPrimary)
            }
            .frame(maxWidth: .infinity)

            // Previous
            Button {
                player.skipToPrevious()
            } label: {
                Image(systemName: "backward.fill")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.tuneBoxPrimary)
            }
            .frame(maxWidth: .infinity)

            // Play / Pause
            Button {
                player.togglePlayPause()
            } label: {
                Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 44, weight: .medium))
                    .foregroundColor(.tuneBoxPrimary)
                    .frame(width: 64, height: 64)
                    .contentShape(Circle())
            }
            .frame(maxWidth: .infinity)

            // Next
            Button {
                player.skipToNext()
            } label: {
                Image(systemName: "forward.fill")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.tuneBoxPrimary)
            }
            .frame(maxWidth: .infinity)

            // Repeat
            Button {
                player.cycleRepeatMode()
            } label: {
                Image(systemName: player.repeatMode.systemImageName)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(player.repeatMode.isActive ? .tuneBoxAccent : .tuneBoxPrimary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
