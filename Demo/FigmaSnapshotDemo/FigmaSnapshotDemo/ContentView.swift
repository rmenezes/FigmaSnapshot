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
import FigmaSnapshot

struct ContentView: View {
    var body: some View {
        TabView {
            VStack {
                Image(systemName: "globe")
                    .font(.system(size: 100))
            }
            .tabItem {
                Image(systemName: "star")
                Text("home")
            }

            Text("Profile")
                .tabItem {
                    Image(systemName: "star")
                    Text("home")
                }

            Text("Profile")
                .tabItem {
                    Image(systemName: "star")
                    Text("home")
                }

            Text("Profile")
                .tabItem {
                    Image(systemName: "star")
                    Text("home")
                }

            Text("Profile")
                .tabItem {
                    Image(systemName: "star")
                    Text("home")
                }
        }
    }
}

#Preview {
    ContentView()
        .figmaSnapshot("<YOUR_FIGMA_SCREEN_HERE>")
}