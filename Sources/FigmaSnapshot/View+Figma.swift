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

extension View {
    ///
    /// Takes a Figma file URL and a node ID and renders the node in the view as an Image
    ///  - Parameters:
    ///     - fileURL: The Figma file URL
    ///     - opacity: The opacity of the rendered image (between 0.0 and 1.0).
    public func figmaSnapshot(
        _ fileURL: String,
        opacity: Double = 1.0
    ) -> some View {
        do {
            let urlParser = FigmaURLParser()
            let (nodeId, fileId) = try urlParser.parse(from: fileURL)

            return AnyView(
                FigmaSnapshotView(
                    nodeId: nodeId,
                    documentId: fileId,
                    opacity: opacity
                ) {
                    self
                }
            )
        } catch {
            return AnyView(
                ErrorView(error: error.localizedDescription)
            )
        }
    }
}
