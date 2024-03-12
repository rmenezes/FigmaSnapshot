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
import UIKit

final class SnapshotRenderer {
    func snapshot(
        view: some View,
        size: CGSize
    ) -> UIImage? {
        let controller = UIHostingController(rootView: view)
        guard let view = controller.view else { return nil }

        let safeArea = UIApplication.shared.windows.first?.safeAreaInsets ?? .zero

        // Create a new size considering the safe area. This size will be use for the snapshot

        // TODO: - We might me streaming a componenta and a not a full screen so this code needs to be updated.
        let renderingViewportSize = CGSize(
            width: size.width,
            height: safeArea.bottom + size.height + safeArea.top
        )

        view.bounds = CGRect(
            origin: .zero,
            size: size
        )

        // Create the viewport with the safe area
        let renderingViewport = CGRect(
            origin: .zero,
            size: renderingViewportSize
        )

        // Because the screen might be smaller as it might not extend the safe area, we create a background for it
        let backgroundView = UIView(
            frame: CGRect(
                origin: .zero,
                size: renderingViewportSize
            )
        )
        backgroundView.backgroundColor = .white

        let renderer = UIGraphicsImageRenderer(size: renderingViewportSize)

        return renderer.image { _ in
            backgroundView.drawHierarchy(
                in: backgroundView.bounds,
                afterScreenUpdates: true
            )

            view.drawHierarchy(
                in: CGRect(origin: CGPoint(x: safeArea.left, y: safeArea.top), size: size),
                afterScreenUpdates: true
            )
        }
    }
}
