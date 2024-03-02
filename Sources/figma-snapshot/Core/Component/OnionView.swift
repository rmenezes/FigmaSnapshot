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

struct OnionView: View {
    private let image: Image
    private let size: CGSize
    private let opacity: Double

    @StateObject private var viewModel: ViewModel

    init(
        size: CGSize,
        opacity: Double,
        @ViewBuilder image: () -> Image
    ) {
        self.size = size
        self._viewModel = StateObject(
            wrappedValue: ViewModel(
                position: CGPoint(
                    x: Session.shared.position ?? size.width,
                    y: size.height / 2
                )
            )
        )
        self.opacity = opacity
        self.image = image()
    }

    var body: some View {
        ZStack {
            image
                .resizable()
                .scaledToFit()
                .mask(
                    Rectangle()
                        .offset(x: self.viewModel.position.x - self.size.width)
                )
                .opacity(self.opacity)

            Handle()
                .position(self.viewModel.position)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation {
                                self.viewModel.update(
                                    x: min(max(value.location.x, -20), self.size.width)
                                )
                            }
                        }
                )
        }
        .drawingGroup()
        .shadow(radius: 2)
    }
}

private extension OnionView {
    final class ViewModel: ObservableObject {
        @Published
        var position: CGPoint

        init(
            position: CGPoint
        ) {
            self.position = position
        }

        func update(x: Double) {
            self.position.x = x
            Session.shared.position = x
        }
    }
}
