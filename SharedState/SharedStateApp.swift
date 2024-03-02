import ChainedActions
import DistributedUpdates
import SwiftUI

@main
struct SharedStateApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    NavigationLink("Distributed Updates") {
                        ParentView(store: .init(initialState: .init()) { Parent() })
                            .navigationTitle("Distributed Updates")
                    }
                }
                .listStyle(.sidebar)
                .frame(width: 200)
            }
        }
    }
}
