//
//  ProductListView.swift
//  A2_iOS_Naomi_101441399
//
//  Created by usr on 2025-03-28.
//

import SwiftUI
import CoreData

struct ProductListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let products: [Product]

    let backgroundColor = Color(red: 0.8, green: 0.9, blue: 1.0) 
    let primaryTextColor = Color.black

    var body: some View {
        NavigationView {
            List {
                ForEach(products, id: \.self) { product in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(product.name ?? "Unknown")
                            .font(.headline)
                            .foregroundColor(primaryTextColor)

                        Text(product.productDescription ?? "No Description")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text("Price: $\(product.price, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color(UIColor.systemBackground))
                    .contextMenu {
                        Button(action: {
                            deleteProduct(product: product)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Product List")
            .background(backgroundColor.edgesIgnoringSafeArea(.all))
        }
    }

    private func deleteProduct(product: Product) {
        viewContext.delete(product)
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete product: \(error)")
        }
    }
}
