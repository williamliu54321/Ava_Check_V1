import SwiftUI
import Foundation

@main
struct YourApp: App {
    
    @StateObject
    private var entitlementManager: EntitlementManager

    @StateObject
    private var purchaseManager: PurchaseManager
    
    //dont understand this
    init() {
        let entitlementManager = EntitlementManager()
        let purchaseManager = PurchaseManager(entitlementManager: entitlementManager)

        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
        self._purchaseManager = StateObject(wrappedValue: purchaseManager)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .appBackground()
                .environmentObject(entitlementManager)
                .environmentObject(purchaseManager)
                .task {
                    do {try await purchaseManager.loadProducts()}
                    catch let error{
                        print(error.localizedDescription)
                    }
                    purchaseManager.resetEntitlementsForTesting()
                    await purchaseManager.updatePurchasedProducts()
                }
        }
    }
}
