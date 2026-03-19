import SwiftUI

@main
struct TuneBoxApp: App {
    @StateObject private var library = LibraryManager()
    @StateObject private var player = MusicPlayerManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(library)
                .environmentObject(player)
                .task {
                    await library.scanLibrary()
                }
        }
    }
}
