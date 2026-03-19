import SwiftUI

struct ProgressBarView: View {
    @Binding var currentTime: TimeInterval
    let duration: TimeInterval
    let onSeek: (TimeInterval) -> Void

    @State private var isScrubbing = false
    @State private var scrubTime: TimeInterval = 0

    private var displayTime: TimeInterval {
        isScrubbing ? scrubTime : currentTime
    }

    private var progress: Double {
        duration > 0 ? displayTime / duration : 0
    }

    var body: some View {
        VStack(spacing: 6) {
            // Track
            GeometryReader { geo in
                let width = geo.size.width

                ZStack(alignment: .leading) {
                    // Background track
                    Capsule()
                        .fill(Color(.systemGray4))
                        .frame(height: isScrubbing ? 6 : 4)

                    // Progress fill
                    Capsule()
                        .fill(Color.tuneBoxPrimary)
                        .frame(width: max(0, CGFloat(progress) * width), height: isScrubbing ? 6 : 4)

                    // Thumb (only when scrubbing)
                    if isScrubbing {
                        Circle()
                            .fill(Color.tuneBoxPrimary)
                            .frame(width: 14, height: 14)
                            .offset(x: max(0, CGFloat(progress) * width - 7))
                    }
                }
                .animation(.easeInOut(duration: 0.1), value: isScrubbing)
                .contentShape(Rectangle().size(CGSize(width: width, height: 44)))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isScrubbing = true
                            let fraction = max(0, min(1, value.location.x / width))
                            scrubTime = fraction * duration
                        }
                        .onEnded { value in
                            let fraction = max(0, min(1, value.location.x / width))
                            let seekTime = fraction * duration
                            onSeek(seekTime)
                            isScrubbing = false
                        }
                )
            }
            .frame(height: 20)

            // Time labels
            HStack {
                Text(displayTime.formattedAsTrackTime())
                    .font(.timeLabel)
                    .foregroundColor(.tuneBoxSecondary)
                Spacer()
                Text((duration - displayTime).formattedAsRemainingTime())
                    .font(.timeLabel)
                    .foregroundColor(.tuneBoxSecondary)
            }
        }
    }
}
