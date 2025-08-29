//
//  ReturnChallanCell.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 09/01/25.
//

import SwiftUI

struct QRScanCell: View {
    var index: Int
    var title: String
    var imageName: String
    var onTap: (Int) -> Void
    var body: some View {
        VStack {
            ZStack {
                Color.blue.opacity(0.2)
                    .cornerRadius(8)
                    .frame(width: UIScreen.main.bounds.width / 2 - 20, height: 150)
                VStack{
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                    Text(title)
                        .font(.headline)
                }
            }
            .onTapGesture {
                onTap(index) 
            }
        }
    }
}
