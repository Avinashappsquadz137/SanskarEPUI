//
//  ViewModifierExtensions.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 02/07/25.
//
import SwiftUI

struct SearchBars: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(10)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Spacer()
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 8)
                        }
                    }
                )
                .padding(.horizontal)
                .padding(.top, 8)
        }
    }
}
