import SwiftUI

struct AlbumDetailView: View {
    let album: Album
    @EnvironmentObject var player: MusicPlayerManager

    var body: some View {
        List {
            // Header
            VStack(spacing: 12) {
                ArtworkImageView(image: album.artwork, size: 220, cornerRadius: 10)
                    .shadow(color: .black.opacity(0.25), radius: 16, x: 0, y: 8)
                    .padding(.top, 16)

                VStack(spacing: 4) {
                    Text(album.title)
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)

                    Text(album.albumArtist)
                        .font(.subheadline)
                        .foregroundColor(.tuneBoxAccent)
                }

                // Play All button
                Button {
                    if let first = album.songs.first {
                        player.play(song: first, in: album.songs)
                    }
                } label: {
                    Label("Play", systemImage: "play.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.tuneBoxAccent)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .padding(.horizontal, 32)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .frame(maxWidth: .infinity)

            // Track list grouped by disc
            let discs = Dictionary(grouping: album.songs, by: { $0.discNumber ?? 1 })
            ForEach(discs.keys.sorted(), id: \.self) { disc in
                if discs.count > 1 {
                    Section(header: Text("Disc \(disc)").font(.sectionHeader)) {
                        trackRows(for: discs[disc] ?? [])
                    }
                } else {
                    Section {
                        trackRows(for: discs[disc] ?? [])
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(album.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func trackRows(for songs: [Song]) -> some View {
        ForEach(songs) { song in
            HStack(spacing: 12) {
                Text("\(song.trackNumber ?? 0)")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.tuneBoxTertiary)
                    .frame(width: 24, alignment: .center)

                VStack(alignment: .leading, spacing: 2) {
                    Text(song.title)
                        .font(.songTitle)
                        .foregroundColor(player.currentSong == song ? .tuneBoxAccent : .tuneBoxPrimary)
                        .lineLimit(1)
                    Text(song.artist)
                        .font(.songSubtitle)
                        .foregroundColor(.tuneBoxSecondary)
                        .lineLimit(1)
                }

                Spacer()

                Text(song.duration.formattedAsTrackTime())
                    .font(.songDuration)
                    .foregroundColor(.tuneBoxTertiary)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                player.play(song: song, in: album.songs)
            }
        }
    }
}
