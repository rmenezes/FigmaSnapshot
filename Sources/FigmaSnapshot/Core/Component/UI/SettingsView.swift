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

struct SettingsView: View {
    @Binding var isSettingsOn: Bool
    @Binding var opacity: Double
    @Binding var showDifference: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()

                Button(action: {
                    withAnimation(.spring) {
                        self.isSettingsOn = false
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .frame(width: 24, height: 24)
                })
            }

            Divider()

            Section {
                Text("Opacity")
                    .font(.headline)

                Slider(
                    value: self.$opacity,
                    in: 0...1
                )
            }
            .disabled(self.showDifference)

            Divider()

            Section {
                Toggle(isOn: self.$showDifference) {
                    Text("Show Difference")
                        .font(.headline)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .onTapGesture {
            withAnimation {
                self.isSettingsOn = false
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 10)
        .padding(16)
        .transition(.slide)
        .animation(.bouncy)
    }
}

#Preview {
    SettingsView(
        isSettingsOn: .constant(false),
        opacity: .constant(1.0),
        showDifference: .constant(false)
    )
}
