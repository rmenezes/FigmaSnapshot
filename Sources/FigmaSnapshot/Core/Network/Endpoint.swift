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

enum HTTPMethod {
    case get
}

protocol Endpoint {
    var url: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: String] { get }
}

extension Endpoint {
    var parameters: [String: String] {
        [:]
    }
}

protocol AuthenticatedEndpoint: Endpoint {
    var accessToken: AccessToken { get }
}

enum AuthenticatedEndpointError: LocalizedError {
    case missingAccessToken

    var errorDescription: String? {
        switch self {
        case .missingAccessToken:
            return "Missing access token. Make sure you set on your environment the key FIGMA_ACCESS_TOKEN with your token"
        }
    }
}
