//
//  FavoriteButton.swift
//  Landmarks
//
//  Created by C4rl0s on 11/02/24.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    var body: some View {
        Text("Hello, Carlos!")
    }
}

#Preview {
    FavoriteButton(isSet: .constant(true))
}
