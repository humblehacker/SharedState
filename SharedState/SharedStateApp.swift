import DistributedUpdates
import SwiftUI

@main
struct SharedStateApp: App {
    var body: some Scene {
        WindowGroup {
            ParentView(store: .init(initialState: .init()) { Parent() })
        }
    }
}
