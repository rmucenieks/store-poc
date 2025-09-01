import SwiftUI

struct CartView: View {
    @ObservedObject var vm: CartViewModel
    @Environment(\.dismiss) private var dismiss

    init(vm: CartViewModel) {
        self.vm = vm
    }

    var body: some View {
        VStack(spacing: 0) {
            if vm.cartItems.isEmpty {
                emptyCartView
            } else {
                cartItemsList
                purchaseSection
            }
        }
        .navigationTitle(Text(vm.localizer.localized("cart")))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(vm.localizer.localized("close")) {
                    dismiss()
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                if !vm.cartItems.isEmpty {
                    Button(vm.localizer.localized("clear")) {
                        vm.clearCart()
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .alert(vm.localizer.localized("purchase_successful"), isPresented: $vm.showingPurchaseSuccess) {
            Button("OK") {
                vm.clearCart()
                dismiss()
            }
        } message: {
            Text(vm.localizer.localized("your_items_have_been_successfully_purchased"))
        }
    }

    private var emptyCartView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "cart")
                .font(.system(size: 64))
                .foregroundColor(.gray)
            
            Text(vm.localizer.localized("your_cart_is_empty"))
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(vm.localizer.localized("add_some_products_to_get_started"))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
    }
    
    private var cartItemsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(vm.cartItems) { item in

                    NavigationLink(destination: ProductDetailView(vm: ProductDetailViewModel(product: item.product,
                                                                                             repository: UProductDetailsRepository(localizer: vm.localizer),
                                                                                             imgRepository: UImageRepository(),
                                                                                             localizer: vm.localizer), cartViewModel: vm)) {


                        CartItemRow(
                            item: item,
                            imgRepository: UImageRepository(),
                            onQuantityChange: { newQuantity in
                                vm.updateQuantity(for: item, newQuantity: newQuantity)
                            },
                            onRemove: {
                                vm.removeFromCart(item: item)
                            }
                        )

                    }
                    .buttonStyle(PlainButtonStyle())

                }
            }
            .padding()
        }
    }
    
    private var purchaseSection: some View {
        VStack(spacing: 16) {
            Divider()
            
            // Summary
            VStack(spacing: 8) {
                HStack {
                    Text(vm.localizer.localized("total_items"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(vm.totalItems)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text(vm.localizer.localized("total_price"))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("€\(String(format: "%.2f", vm.totalPrice))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            // Purchase Button
            Button(action: {
                vm.purchaseItems()
            }) {
                HStack {
                    Image(systemName: "creditcard.fill")
                                            Text(vm.localizer.localized("purchase_items"))
                }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    let localizer =  MockLocalizer(overrides: [:])

    let cartVM = CartViewModel(localizer: localizer)
    cartVM.addToCart(product: Product.productDemoItem, quantity: 2)
    return CartView(vm: cartVM)
}
