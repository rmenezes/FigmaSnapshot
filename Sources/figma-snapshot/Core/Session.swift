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

final class Session {
    static let shared = Session()

    private let storage: Storage

    init() {
        self.storage = Storage()
    }

    var token: String? {
        ProcessInfo.processInfo.environment["FIGMA_ACCESS_TOKEN"]
    }

    var position: Double? {
        get {
            self.storage.read("position")
        }
        set {
            guard let newValue = newValue else { return }
            self.storage.write("position", value: newValue)
        }
    }
}

private extension Session {
    final class Storage {
        private let userDefaults: UserDefaults

        init() {
            self.userDefaults = UserDefaults(suiteName: "me.rmenezes.figma-plugin")!
        }

        func write<T>(
            _ key: String,
            value: T
        ) {
            self.userDefaults.setValue(value, forKey: key)
        }

        func read<T>(
            _ key: String
        ) -> T? {
            guard
                let value = self.userDefaults.value(forKey: key) as? T
            else { return nil }

            return value
        }
    }

}
