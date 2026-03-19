import SwiftUI

struct ArtworkImageView: View {
    let image: UIImage?
    var size: CGFloat? = nil
    var cornerRadius: CGFloat = 4

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ZStack {
                    Color(.systemGray5)
                    Image(systemName: "music.note")
                        .font(.system(size: (size ?? 60) * 0.35, weight: .light))
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

#Preview {
    ArtworkImageView(image: nil, size: 60)
}
