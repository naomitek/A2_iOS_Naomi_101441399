//
//  AddProductView.swift
//  A2_iOS_Naomi_101441399
//
//  Created by usr on 2025-03-28.
//

import SwiftUI
import CoreData

struct AddProductView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var name = ""
    @State private var provider = ""
    @State private var price = ""
    @State private var description = ""
    @State private var isPriceValid = true
    @State private var showAlert = false
    @State private var alertMessage = ""

    let backgroundColor = Color(red: 0.6, green: 0.8, blue: 1.0)

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Add Product")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.4))
                        .padding(.top, 30)

                    VStack(spacing: 18) {
                        CustomTextField(title: "Product Name", text: $name, primaryColor: Color(red: 0.1, green: 0.2, blue: 0.4), secondaryColor: Color(UIColor.systemBackground))
                        CustomTextField(title: "Provider", text: $provider, primaryColor: Color(red: 0.1, green: 0.2, blue: 0.4), secondaryColor: Color(UIColor.systemBackground))
                        CustomTextField(title: "Price", text: $price, keyboardType: .decimalPad, primaryColor: Color(red: 0.1, green: 0.2, blue: 0.4), secondaryColor: Color(UIColor.systemBackground))
                            .onChange(of: price) { newValue in
                                isPriceValid = Double(newValue) != nil && !newValue.isEmpty
                            }
                            .foregroundColor(isPriceValid ? Color(red: 0.1, green: 0.2, blue: 0.4) : Color(red: 0.9, green: 0.3, blue: 0.3))

                        if !isPriceValid && !price.isEmpty {
                            Text("Please enter a valid price.")
                                .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.3))
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        CustomTextField(title: "Description", text: $description, isMultiline: true, primaryColor: Color(red: 0.1, green: 0.2, blue: 0.4), secondaryColor: Color(UIColor.systemBackground))
                        // Removed: CustomTextField(title: "Image Name", text: $imageName, primaryColor: Color(red: 0.1, green: 0.2, blue: 0.4), secondaryColor: Color(UIColor.systemBackground))
                    }
                    .padding(22)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)

                    Button(action: addProduct) {
                        Text("Add Product")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(name.isEmpty || provider.isEmpty || price.isEmpty || !isPriceValid ? Color.gray : Color(red: 0.3, green: 0.7, blue: 0.9))
                            .cornerRadius(12)
                    }
                    .disabled(name.isEmpty || provider.isEmpty || price.isEmpty || !isPriceValid)

                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
            .background(backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationBarItems(trailing: Button("Cancel") {
                Text("Cancel")
                    .foregroundColor(.black) // Change color to black here
            })
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func addProduct() {
        guard let priceValue = Double(price), priceValue > 0 else {
            alertMessage = "Please enter a valid price greater than 0."
            showAlert = true
            return
        }

        let newProduct = Product(context: viewContext)
        newProduct.productID = UUID()
        newProduct.name = name
        newProduct.provider = provider
        newProduct.price = priceValue
        newProduct.productDescription = description

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to save product: \(error.localizedDescription)")
            alertMessage = "Failed to save product: \(error.localizedDescription)"
            showAlert = true
        }
    }
}
