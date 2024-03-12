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
import SwiftUI

enum SnapshotEvent: Sendable {
    case onAppear(
        documentId: String,
        nodeId: String
    )
    case snapshotDismissed
    case snapshot(UIImage?)
}

enum SnapshotState: Sendable, Equatable {
    case loading
    case error(String)
    case figmaImage(Image)
    case diff(Image)
}

protocol SnapshotViewModel: ObservableObject {
    @MainActor
    var state: SnapshotState { get }

    func send(_ event: SnapshotEvent) async
}

final class FigmaSnapshotViewModel: ObservableObject {
    // MARK: - Private

    private let service: RestService
    private let diffService: DiffService
    private var image: UIImage?

    // MARK: - Public

    @Published var state: SnapshotState = .loading

    init() {
        self.service = RestService(
            baseURL: "https://api.figma.com"
        )
        self.diffService = DiffService()
    }
}

// MARK: - SnapshotViewModel

extension FigmaSnapshotViewModel: SnapshotViewModel {
    func send(_ event: SnapshotEvent) {
        switch event {
        case let .onAppear(documentId, nodeId):
            if let image = self.image {
                self.update(
                    .figmaImage(
                        Image(uiImage: image)
                    )
                )
            } else {
                Task {
                    do {
                        let image = try await self.fetchFigmaImage(documentId: documentId, nodeId: nodeId)
                        self.update(
                            .figmaImage(
                                Image(
                                    uiImage: image
                                )
                            )
                        )
                        self.image = image
                    } catch {
                        self.update(
                            .error(
                                error.localizedDescription
                            )
                        )
                    }
                }
            }
        case let .snapshot(view):
            guard
                let remoteImage = self.image,
                let view,
                let diffImage = self.diffService.diff(
                    view,
                    remoteImage
                )
            else { return }

            self.update(
                .diff(diffImage)
            )
        case .snapshotDismissed:
            if let image = self.image {
                self.update(
                    .figmaImage(
                        Image(uiImage: image)
                    )
                )
            }
        }
    }

    private func update(
        _ state: SnapshotState
    ) {
        DispatchQueue.main.async {
            self.state = state
        }
    }
}

// MARK: - Private

private extension FigmaSnapshotViewModel {
    func fetchFigmaImage(
        documentId: String,
        nodeId: String
    ) async throws -> UIImage {
        guard
            let accessToken = Session.shared.token
        else { throw Error.missingAccessToken }

        let endpoint = try FigmaEndpoint(
            documentId: documentId,
            nodeId: nodeId,
            scale: "3x",
            accessToken: accessToken
        )

        let response: FigmaResponse = try await self.service.get(endpoint)

        guard
            let imageUrl = response.images.first?.value
        else { throw Error.missingImageURL }

        let imageContent = try await self.service.download(imageUrl)

        guard
            let image = UIImage(data: imageContent)
        else { throw  Error.invalidImageData }

        return image
    }
}

// MARK: - FigmaError

extension FigmaSnapshotViewModel {
    enum Error: LocalizedError {
        case missingAccessToken
        case missingImageURL
        case invalidImageData

        var errorDescription: String? {
            switch self {
            case .missingAccessToken:
                return "Missing access token"
            case .missingImageURL:
                return "Missing image URL"
            case .invalidImageData:
                return "Invalid image data"
            }
        }
    }
}
