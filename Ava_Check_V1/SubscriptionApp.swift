import SwiftUI

@main
struct storekit_2_demo_appApp: App {
    
    @StateObject
    private var entitlementManager: EntitlementManager
    
    @StateObject
    private var subscriptionsManager: SubscriptionsManager
    
    init() {
        let entitlementManager = EntitlementManager()
        let subscriptionsManager = SubscriptionsManager(entitlementManager: entitlementManager)
        
        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
        self._subscriptionsManager = StateObject(wrappedValue: subscriptionsManager)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(entitlementManager)
                .environmentObject(subscriptionsManager)
                .task {
                    await subscriptionsManager.updatePurchasedProducts()
                }
        }
    }
}
