//
//  CustomTextField.swift
//  A2_iOS_Naomi_101441399
//
//  Created by usr on 2025-03-28.
//

import SwiftUI
struct CustomTextField: View {
    var title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isMultiline: Bool = false
    var primaryColor: Color
    var secondaryColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(primaryColor)

            if isMultiline {
                TextEditor(text: $text) // Correctly using TextEditor
                    .padding(12)
                    .background(secondaryColor)
                    .cornerRadius(10)
                    .frame(minHeight: 120) // Ensure a reasonable minHeight
            } else {
                TextField(title, text: $text)
                    .padding(12)
                    .background(secondaryColor)
                    .cornerRadius(10)
                    .keyboardType(keyboardType)
            }
        }
    }
}
