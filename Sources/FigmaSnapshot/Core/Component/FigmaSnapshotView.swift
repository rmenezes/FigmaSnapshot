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

struct FigmaSnapshotView<Content: View>: View {
    private let content: Content
    private let nodeId: String
    private let documentId: String
    private let opacity: Double

    @State private var state: SnapshotState?

    @StateObject private var viewModel = FigmaSnapshotViewModel()

    init(
        nodeId: String,
        documentId: String,
        opacity: Double,
        @ViewBuilder content: () -> Content
    ) {
        self.nodeId = nodeId
        self.documentId = documentId
        self.opacity = opacity
        self.content = content()
    }

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .overlay(self.content)
                .overlay(
                    self.makeImage(
                        size: proxy.size
                    )
                )
                .onAppear {
                    self.viewModel.send(
                        .onAppear(
                            documentId: self.documentId,
                            nodeId: self.nodeId
                        )
                    )
                }
                .onReceive(self.viewModel.$state) {
                    self.state = $0
                }
                .ignoresSafeArea()
        }
    }
}

// MARK: - Private

private extension FigmaSnapshotView {
    @ViewBuilder
    func makeImage(
        size: CGSize
    ) -> some View {
        switch self.state {
        case .loading:
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        case let .error(message):
            Text(message)
        case let .content(image):
            OnionView(
                size: size,
                opacity: self.opacity
            ) {
                image
            }
        case .none:
            EmptyView()
        }
    }
}
