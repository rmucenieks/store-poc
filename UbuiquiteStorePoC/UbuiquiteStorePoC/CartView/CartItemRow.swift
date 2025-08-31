import SwiftUI

struct CartItemRow: View {
    let item: CartItem
    let imgRepository: ImageRepository
    let onQuantityChange: ((Int) -> Void)?
    let onRemove: VoidFunc?
    let onTap: ((Product) -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            // Product Image
            AsyncImage(url: imgRepository.getImageURL(for: item.product.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(item.product.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text("€\(String(format: "%.2f", item.product.price))")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    
                    Text("× \(item.quantity)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Quantity Controls
            VStack(spacing: 8) {
                // Remove Button
                Button(action: {
                    onRemove?()
                }) {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
                
                // Quantity Stepper
                HStack(spacing: 0) {
                    Button(action: {
                        onQuantityChange?(item.quantity - 1)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text("\(item.quantity)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .frame(minWidth: 30)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        onQuantityChange?(item.quantity + 1)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
//        .onTapGesture {
//            // Handle tap
//            onTap?(item.product)
//        }
    }
}

#Preview {
    let imgRepo = UImageRepository()
    CartItemRow(
        item: CartItem(product: Product.productDemoItem, quantity: 2),
        imgRepository: imgRepo,
        onQuantityChange: nil,
        onRemove: nil,
        onTap: nil
    )
    .padding()
}
