import SwiftUI

struct ArtworkView: View {
    let image: UIImage?
    let isPlaying: Bool

    var body: some View {
        ArtworkImageView(image: image, size: .infinity, cornerRadius: 12)
            .aspectRatio(1, contentMode: .fit)
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 8)
            .scaleEffect(isPlaying ? 1.0 : 0.93)
            .animation(.spring(response: 0.4, dampingFraction: 0.65, blendDuration: 0), value: isPlaying)
    }
}
