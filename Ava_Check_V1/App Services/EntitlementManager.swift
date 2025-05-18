import SwiftUI

class EntitlementManager: ObservableObject {
    @AppStorage("hasPro")
    var hasPro: Bool = false
}
