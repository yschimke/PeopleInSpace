import SwiftUI
import common

@main
struct PeopleInSpaceXtoolApp: App {
    init() {
        // Bring up the shared Koin graph, exactly like the Xcode app does.
        KoinKt.doInitKoin()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
