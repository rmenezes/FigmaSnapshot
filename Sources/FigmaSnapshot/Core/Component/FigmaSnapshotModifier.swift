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

struct FigmaSnapshotModifier: ViewModifier {
    let url: String
    let urlParser: FigmaURLParser
    let opacity: Double

    init(
        url: String,
        opacity: Double
    ) {
        self.url = url
        self.opacity = opacity
        self.urlParser = FigmaURLParser()
    }

    func body(
        content: Content
    ) -> some View {
        do {
            let (nodeId, fileId) = try urlParser.parse(from: self.url)

            return AnyView(
                FigmaSnapshotView(
                    nodeId: nodeId,
                    documentId: fileId,
                    opacity: self.opacity
                ) {
                    content
                }
            )
        } catch {
            return AnyView(
                FigmaErrorView(error: error.localizedDescription)
            )
        }
    }
}
