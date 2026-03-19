import SwiftUI

struct MarqueeText: View {
    let text: String
    let font: Font
    let color: Color

    @State private var offset: CGFloat = 0
    @State private var textWidth: CGFloat = 0
    @State private var containerWidth: CGFloat = 0
    @State private var isAnimating = false

    private var needsScrolling: Bool {
        textWidth > containerWidth
    }

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            Text(text)
                .font(font)
                .foregroundColor(color)
                .fixedSize()
                .offset(x: offset)
                .onAppear {
                    containerWidth = width
                }
                .onChange(of: textWidth) { _ in startAnimationIfNeeded() }
                .onChange(of: containerWidth) { _ in startAnimationIfNeeded() }
                .background(
                    Text(text)
                        .font(font)
                        .fixedSize()
                        .hidden()
                        .background(
                            GeometryReader { textGeo in
                                Color.clear.onAppear {
                                    textWidth = textGeo.size.width
                                }
                            }
                        )
                )
        }
        .clipped()
    }

    private func startAnimationIfNeeded() {
        guard needsScrolling, !isAnimating else { return }
        isAnimating = true
        let scrollDistance = textWidth - containerWidth + 20
        withAnimation(.linear(duration: Double(scrollDistance) / 30).delay(1.5).repeatForever(autoreverses: true)) {
            offset = -scrollDistance
        }
    }
}
