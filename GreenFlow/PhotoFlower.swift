//
//  PhotoFlower.swift
//  GreenFlow
//
//  Created by Mykhailo Kravchuk on 29/04/2024.
//

import SwiftUI

struct PhotoFlower: View {
    var body: some View {
        VStack{
            Image("image1")
            
                .resizable()
                .scaledToFill()
                .frame(width: 450,height: 600)
                .clipShape(RoundedCorner(radius: 50, corners: [.topLeft, .topRight]))
                .ignoresSafeArea()
        }
    }
}

#Preview {
    PhotoFlower()
}
