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

import Foundation

final class FigmaURLParser {
    func parse(
        from url: String
    ) throws -> (fileID: String, nodeID: String) {
        guard let url = URL(string: url),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false) 
        else { throw Error.invalidURL }

        let pathComponents = components.path.components(separatedBy: "/")

        guard
            pathComponents.count > 2,
            let nodeId = components.queryItems?.first(where: { $0.name == "node-id" })?.value
        else { throw Error.missingNodeIdOrFileID }

        return (nodeId, pathComponents[2])
    }
}

// MARK: - Error

extension FigmaURLParser {
    enum Error: LocalizedError {
        case invalidURL
        case missingNodeIdOrFileID

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid File URL"
            case .missingNodeIdOrFileID:
                return "Missing Node ID or File ID"
            }
        }
    }
}
