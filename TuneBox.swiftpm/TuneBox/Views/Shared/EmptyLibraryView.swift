import SwiftUI

struct EmptyLibraryView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "music.note.list")
                .font(.system(size: 60, weight: .thin))
                .foregroundColor(.secondary)

            Text("No Music Found")
                .font(.title2.bold())

            Text("Add music files to the TuneBox folder in the Files app.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyLibraryView()
}
