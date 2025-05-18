import Foundation
import StoreKit
import SwiftUI 

@MainActor
class PurchaseManager: ObservableObject {
    
    private let productIds = ["avacheck_proaccess_monthly", "avacheck_proaccess_annual"]
        
    @Published
     var products: [Product] = []
    private var productsLoaded = false
    
    
    @Published
     var purchasedProductIDs = Set<String>()
    
    @Published
    private(set) var isLoadingPro: Bool = false

    var hasUnlockedPro: Bool {
       return !self.purchasedProductIDs.isEmpty
    }
    
    private var updates: Task<Void, Never>? = nil
    
    
    private let entitlementManager: EntitlementManager
    
    init(entitlementManager: EntitlementManager) {
        self.entitlementManager = entitlementManager
        self.isLoadingPro = true  // Start with loading state
        self.updates = observeTransactionUpdates()
    }

    deinit {
        updates?.cancel()
    }


    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: productIds)
        self.productsLoaded = true
    }

    func purchase(_ product: Product) async throws {
            let result = try await product.purchase()

            switch result {
            case let .success(.verified(transaction)):
                // Successful purhcase
                await transaction.finish()
                await self.updatePurchasedProducts()
            case let .success(.unverified(_, error)):
                // Successful purchase but transaction/receipt can't be verified
                // Could be a jailbroken phone
                break
            case .pending:
                // Transaction waiting on SCA (Strong Customer Authentication) or
                // approval from Ask to Buy
                break
            case .userCancelled:
                // ^^^
                break
            @unknown default:
                break
            }
        }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in // Wtf is unowned self
            for await verificationResult in Transaction.updates {
                // Using verificationResult directly would be better
                // but this way works for this tutorial
                await self.updatePurchasedProducts()
            }
        }
    }


    func updatePurchasedProducts() async {
        
        DispatchQueue.main.async {
               self.isLoadingPro = true
           }
        
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }

        self.entitlementManager.hasPro = !self.purchasedProductIDs.isEmpty
        
        DispatchQueue.main.async {
            self.isLoadingPro = false
        }

    }
    
    // In EntitlementManager
    func resetEntitlementsForTesting() {
        // Clear the hasUnlockedPro status
        purchasedProductIDs.removeAll()
        
        // Clear from UserDefaults
        UserDefaults.standard.removeObject(forKey: "hasUnlockedPro")
        
        // Any other entitlement states you're storing
        // UserDefaults.standard.removeObject(forKey: "purchasedFeatures")
        
        print("🧹 Entitlements have been reset for testing")
    }

}

