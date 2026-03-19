import SwiftUI
import MediaPlayer

struct VolumeView: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let view = MPVolumeView()
        view.showsRouteButton = false
        view.setVolumeThumbImage(UIImage(), for: .normal)
        return view
    }

    func updateUIView(_ uiView: MPVolumeView, context: Context) {}
}

struct VolumeControlView: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "speaker.fill")
                .font(.system(size: 14))
                .foregroundColor(.tuneBoxTertiary)

            VolumeView()
                .frame(height: 32)

            Image(systemName: "speaker.wave.3.fill")
                .font(.system(size: 14))
                .foregroundColor(.tuneBoxTertiary)
        }
    }
}
