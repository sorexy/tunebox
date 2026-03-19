import SwiftUI

struct NowPlayingHeaderView: View {
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            // Drag indicator
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(Color(.systemGray3))
                .frame(width: 36, height: 5)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack {
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.tuneBoxPrimary)
                        .padding(8)
                }

                Spacer()

                Text("Now Playing")
                    .font(.nowPlayingHeader)
                    .foregroundColor(.tuneBoxSecondary)
                    .textCase(.uppercase)

                Spacer()

                // Spacer to balance the chevron
                Color.clear
                    .frame(width: 36, height: 36)
            }
        }
        .padding(.top, 12)
        .padding(.horizontal, 24)
    }
}
