//
//  ToggleIN2.swift
//  GreenFlow
//
//  Created by Mykhailo Kravchuk on 28/04/2024.
//

import SwiftUI

struct ToggleButton: View {
    
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: title)
                .padding(15)
                .scaleEffect(1.5)
                
        }
    }
}



struct ToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        ToggleButton(title: "lightbulb", action: {})
    }
}

