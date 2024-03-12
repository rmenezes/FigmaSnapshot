//
//  FigmaSnapshot
//
//  Copyright (C) 2024 Raul Menezes <raul@rmenezes.me>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
//

import SwiftUI

struct DiffButton: View {
    @State private var isShowingDiff = false

    let onDiff: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        Image(systemName: isShowingDiff ? "eye" : "eye.slash")
            .onTapGesture {
                isShowingDiff.toggle()

                if isShowingDiff {
                    onDiff()
                } else {
                    onDismiss()
                }
            }
            .font(.system(size: 15))
            .frame(width: 20, height: 20)
            .padding(8)
            .background(
                Circle()
                    .fill(Color.gray)
                    .overlay(
                        RadialGradient(
                            colors: [
                                .clear,
                                .gray
                            ],
                            center: .center,
                            startRadius: 1,
                            endRadius: 100
                        )
                        .opacity(0.6)
                    )
                    .opacity(0.4)
                    .blur(radius: 4)
                    .clipShape(Circle())
            )
            .drawingGroup()
            .shadow(radius: 4)
    }
}

#Preview {
    DiffButton {
        print("Diff")
    } onDismiss: {
        print("Dismiss")
    }
}
