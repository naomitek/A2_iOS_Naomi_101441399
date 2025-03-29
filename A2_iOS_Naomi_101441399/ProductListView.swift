//
//  ProductListView.swift
//  A2_iOS_Naomi_101441399
//
//  Created by usr on 2025-03-28.
//

import SwiftUI
import CoreData

struct ProductListView: View {
    let products: [Product]
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showingDeleteAlert = false
    @State private var productToDelete: Product?

    let backgroundColor = Color(red: 0.6, green: 0.8, blue: 1.0)

    var body: some View {
        NavigationView {
            List {
                ForEach(products, id: \.self) { product in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(product.name ?? "Unknown")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.4))
                        Text(product.productDescription ?? "No Description")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)
                    .contextMenu {
                        Button(action: {
                            productToDelete = product
                            showingDeleteAlert = true
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Product List")
            .background(backgroundColor.edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Delete Product?"),
                    message: Text("Are you sure you want to delete this product?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let product = productToDelete {
                            deleteProduct(product: product)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
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
