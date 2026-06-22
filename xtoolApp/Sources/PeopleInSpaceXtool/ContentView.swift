import SwiftUI
import common

/// Minimal SwiftUI front-end over the shared KMP module, consumed through the
/// `PeopleInSpaceKit` XCFramework that xtool assembles + embeds. It exercises the
/// same shared API as the full Xcode app (`PersonListViewModel`, `Assignment`,
/// and SKIE's `Observing` / `onEnum`) to prove the framework is wired correctly.
struct ContentView: View {
    @State private var viewModel = PersonListViewModel()

    var body: some View {
        NavigationStack {
            Observing(viewModel.uiState) { uiState in
                switch onEnum(of: uiState) {
                case .loading:
                    ProgressView("Loading astronauts…")
                case .error(let error):
                    Text("Error: \(error)")
                case .success(let success):
                    List(success.result, id: \.name) { person in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(person.name).font(.headline)
                            Text(person.craft).font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("People In Space")
        }
    }
}
