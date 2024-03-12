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

final class DiffService {
    func diff(
        _ snapshot: UIImage,
        _ reference: UIImage
    ) -> Image? {
        let width = max(reference.size.width, snapshot.size.width)
        let height = max(reference.size.height, snapshot.size.height)
        let scale = max(reference.scale, snapshot.scale)

        let size = CGSize(width: width, height: height)
        let rect = CGRect(origin: .zero, size: size)

        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = true

        let renderer = UIGraphicsImageRenderer(
            size: size,
            format: format
        )

        let differenceImage = renderer.image { _ in
            snapshot.draw(in: rect)
            reference.draw(in: rect, blendMode: .difference, alpha: 1)
        }

        return Image(uiImage: differenceImage)
    }
}
