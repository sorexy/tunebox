import SwiftUI

struct SongRowView: View {
    let song: Song
    @EnvironmentObject var player: MusicPlayerManager

    var isCurrentSong: Bool {
        player.currentSong == song
    }

    var body: some View {
        HStack(spacing: 12) {
            ArtworkImageView(image: song.artwork, size: 50, cornerRadius: 4)

            VStack(alignment: .leading, spacing: 2) {
                Text(song.title)
                    .font(.songTitle)
                    .foregroundColor(isCurrentSong ? .tuneBoxAccent : .tuneBoxPrimary)
                    .lineLimit(1)

                Text("\(song.artist) — \(song.albumTitle)")
                    .font(.songSubtitle)
                    .foregroundColor(.tuneBoxSecondary)
                    .lineLimit(1)
            }

            Spacer()

            if isCurrentSong && player.isPlaying {
                Image(systemName: "waveform")
                    .font(.system(size: 14))
                    .foregroundColor(.tuneBoxAccent)
            } else {
                Text(song.duration.formattedAsTrackTime())
                    .font(.songDuration)
                    .foregroundColor(.tuneBoxTertiary)
            }
        }
        .contentShape(Rectangle())
    }
}
