//
//  SwiftUIView.swift
//  
//
//  Created by Raul Menezes on 02/03/2024.
//

import SwiftUI

struct Handle: View {
    var body: some View {
        Image(systemName: "arrow.left.and.line.vertical.and.arrow.right")
            .font(.system(size: 20))
            .foregroundColor(.black)
    }
}

#Preview {
    Handle()
}
