//
//   CustomTextField.swift
//  A2_iOS_Naomi_101441399
//
//  Created by usr on 2025-03-28.
//
import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isMultiline: Bool = false
    var primaryColor: Color = .primary
    var secondaryColor: Color = Color(UIColor.systemBackground)

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(primaryColor)

            if isMultiline {
                TextEditor(text: $text)
                    .padding(8)
                    .background(secondaryColor)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            } else {
                TextField("", text: $text)
                    .padding(8)
                    .background(secondaryColor)
                    .cornerRadius(8)
                    .keyboardType(keyboardType)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }
}

