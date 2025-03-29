//
//  ProductDetailView.swift
//  A2_iOS_Naomi_101441399
//
//  Created by usr on 2025-03-28.
//

import SwiftUI
import CoreData

struct ProductDetailView: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(product.name ?? "Unknown Product")
                .font(.title)
                .fontWeight(.bold)

            Text("ID: \(product.productID?.uuidString ?? "N/A")")
                .font(.subheadline)

            Text("Description: \(product.productDescription ?? "N/A")")
                .font(.body)

            Text("Price: $\(product.price, specifier: "%.2f")")
                .font(.body)

            Text("Provider: \(product.provider ?? "N/A")")
                .font(.body)

            if let imageName = product.imagename {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }

            Spacer()
        }
        .padding()
        .background(Color(red: 0.6, green: 0.8, blue: 1.0).edgesIgnoringSafeArea(.all))
    }
}
