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

final class RestService {
    private let urlSession: URLSession
    private let baseURL: String

    init(
        urlSession: URLSession = .shared,
        baseURL: String
    ) {
        self.urlSession = urlSession
        self.baseURL = baseURL
    }

    func download(_ endpoint: String) async throws -> Data {
        guard
            let url = URL(string: endpoint)
        else { throw Error.invalidURL }

        let urlRequest = URLRequest(url: url)

        let (data, _) = try await self.urlSession.data(for: urlRequest)
        return data
    }

    func get<T: Decodable>(
        _ endpoint: Endpoint
    ) async throws -> T {
        guard
            let url = URL(string: self.baseURL)
        else { throw Error.invalidURL }

        guard
            var urlComponents = URLComponents(
                url: url.appendingPathComponent(
                    endpoint.url
                ),
                resolvingAgainstBaseURL: true
            )
        else { throw Error.invalidURL }

        urlComponents.queryItems = endpoint.parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }

        guard let url = urlComponents.url else { throw Error.invalidURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")


        if let authenticatedEndpoint = endpoint as? AuthenticatedEndpoint {
            urlRequest.addValue(
                authenticatedEndpoint.accessToken.token,
                forHTTPHeaderField: "X-Figma-Token"
            )
        }

        let (data, response) = try await self.urlSession.data(for: urlRequest)

        if let response = response as? HTTPURLResponse, 
            response.statusCode != 200 {
            if response.statusCode == 403 {
                throw Error.expiredToken
            }

            throw Error.invalidResponse(response.statusCode)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension RestService {
    enum Error: LocalizedError {
        case invalidURL
        case invalidResponse(Int)
        case expiredToken
        case decodingError

        var errorDescription: String? {
            switch self {
            case .invalidURL: return "Invalid URL"
            case let .invalidResponse(statusCode): return "Invalid Response. Received status code: \(statusCode)"
            case .decodingError: return "Decoding Error"
            case .expiredToken: return "Expired Token"
            }
        }
    }
}
