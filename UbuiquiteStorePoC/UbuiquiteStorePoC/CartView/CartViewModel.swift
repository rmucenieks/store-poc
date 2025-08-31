import Foundation
import SwiftUI

@MainActor
class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    let localizer: Localizer
    @Published var showingPurchaseSuccess = false

    var totalItems: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var isEmpty: Bool {
        cartItems.isEmpty
    }

    init(localizer: Localizer) {
        self.localizer = localizer
    }

    // Add product to cart
    func addToCart(product: Product, quantity: Int = 1) {
        if let existingIndex = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            // Update existing item quantity
            cartItems[existingIndex].quantity += quantity
        } else {
            // Add new item
            let newItem = CartItem(product: product, quantity: quantity)
            cartItems.append(newItem)
        }
        print("🛒 Added to cart: \(product.name) x\(quantity)")
    }
    
    // Remove item from cart
    func removeFromCart(item: CartItem) {
        cartItems.removeAll { $0.id == item.id }
        print("🗑️ Removed from cart: \(item.product.name)")
    }
    
    // Update item quantity
    func updateQuantity(for item: CartItem, newQuantity: Int) {
        guard let index = cartItems.firstIndex(where: { $0.id == item.id }) else { return }
        
        if newQuantity <= 0 {
            removeFromCart(item: item)
        } else {
            cartItems[index].quantity = newQuantity
            print("📝 Updated quantity for \(item.product.name): \(newQuantity)")
        }
    }
    
    // Increment quantity
    func incrementQuantity(for item: CartItem) {
        updateQuantity(for: item, newQuantity: item.quantity + 1)
    }
    
    // Decrement quantity
    func decrementQuantity(for item: CartItem) {
        updateQuantity(for: item, newQuantity: item.quantity - 1)
    }
    
    // Clear cart
    func clearCart() {
        cartItems.removeAll()
        print("🧹 Cart cleared")
    }
    
    // Purchase items
    func purchaseItems() {
        guard !cartItems.isEmpty else { return }
        
        let totalItems = self.totalItems
        let totalPrice = self.totalPrice
        
        print("💳 Purchasing \(totalItems) items for €\(String(format: "%.2f", totalPrice))")
        
        // Show success alert
        showingPurchaseSuccess = true
    }
    
    // Get cart item by product ID
    func getCartItem(for productId: String) -> CartItem? {
        return cartItems.first { $0.product.id == productId }
    }
    
    // Check if product is in cart
    func isProductInCart(productId: String) -> Bool {
        return cartItems.contains { $0.product.id == productId }
    }
}
