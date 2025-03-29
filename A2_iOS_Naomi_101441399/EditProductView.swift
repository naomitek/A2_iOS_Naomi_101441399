//
//  EditProductView.swift
//  A2_iOS_Naomi_101441399
//
//  Created by usr on 2025-03-28.
//

import SwiftUI
import CoreData



struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Product.timestamp, ascending: true)], animation: .default)
    private var products: FetchedResults<Product>

    @State private var selectedProduct: Product?
    @State private var searchText = ""
    @State private var isAddingProduct = false
    @State private var showProductList = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isEditingProduct = false

    let backgroundColor = Color(red: 0.6, green: 0.8, blue: 1.0)
    let deleteButtonColor = Color.red
    let editButtonColor = Color.white

    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return Array(products)
        } else {
            return products.filter { product in
                product.name?.localizedCaseInsensitiveContains(searchText) ?? false ||
                product.productDescription?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if let product = selectedProduct {
                    VStack {
                        ProductDetailView(product: product)
                        HStack {
                            Button(action: {
                                deleteProduct(product: product)
                            }) {
                                Text("Delete")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(deleteButtonColor)
                                    .cornerRadius(8)
                            }

                            Button(action: {
                                isEditingProduct = true
                            }) {
                                Text("Edit")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(editButtonColor)
                                    .cornerRadius(8)
                            }
                        }
                    }
                } else if !filteredProducts.isEmpty {
                    VStack {
                        ProductDetailView(product: filteredProducts.first!)
                        HStack {
                            Button(action: {
                                deleteProduct(product: filteredProducts.first!)
                            }) {
                                Text("Delete")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(deleteButtonColor)
                                    .cornerRadius(8)
                            }

                            Button(action: {
                                isEditingProduct = true
                            }) {
                                Text("Edit")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(editButtonColor)
                                    .cornerRadius(8)
                            }
                        }
                    }
                } else {
                    VStack {
                        Image(systemName: "tray.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No products found.")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(backgroundColor)
                }

                HStack {
                    if !filteredProducts.isEmpty {
                        Button(action: {
                            if let currentIndex = filteredProducts.firstIndex(of: selectedProduct ?? filteredProducts.first!), currentIndex > 0 {
                                selectedProduct = filteredProducts[currentIndex - 1]
                            } else {
                                selectedProduct = filteredProducts.last!
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                        .disabled(filteredProducts.firstIndex(of: selectedProduct ?? filteredProducts.first!) == 0)

                        Spacer()

                        Button(action: {
                            if let currentIndex = filteredProducts.firstIndex(of: selectedProduct ?? filteredProducts.first!), currentIndex < filteredProducts.count - 1 {
                                selectedProduct = filteredProducts[currentIndex + 1]
                            } else {
                                selectedProduct = filteredProducts.first!
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                        .disabled(filteredProducts.firstIndex(of: selectedProduct ?? filteredProducts.first!) == filteredProducts.count - 1)
                    }
                }
                .padding()

                HStack {
                    TextField(products.isEmpty ? "Not Available" : "Search Products", text: $searchText)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .disabled(products.isEmpty)
                        .foregroundColor(products.isEmpty ? .gray : .primary)
                        .onChange(of: searchText) { _ in
                            selectedProduct = filteredProducts.first
                        }

                    Button(action: {
                        showProductList = true
                    }) {
                        Image(systemName: "list.bullet")
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 8)
                    .disabled(products.isEmpty)

                    Button(action: {
                        isAddingProduct = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 8)
                }
                .padding()
            }
            .padding(.bottom)
            .navigationTitle("Products")
            .sheet(isPresented: $isAddingProduct) {
                AddProductView()
            }
            .sheet(isPresented: $showProductList) {
                ProductListView(products: filteredProducts)
            }
            .sheet(isPresented: $isEditingProduct) {
                if let product = selectedProduct {
                    EditProductView(product: Binding(
                        get: { product },
                        set: { selectedProduct = $0 }
                    ))
                }
            }
            .onAppear {
                if let firstProduct = filteredProducts.first {
                    selectedProduct = firstProduct
                }
            }
            .background(backgroundColor.edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func deleteProduct(product: Product) {
        viewContext.delete(product)
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete product: \(error)")
            alertMessage = "Failed to delete product: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}
