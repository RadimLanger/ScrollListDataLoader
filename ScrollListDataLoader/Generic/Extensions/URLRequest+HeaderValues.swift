//
//  URLRequest+HeaderValues.swift
//  ScrollListDataLoader
//
//  Created by Radim Langer on 22/06/2019.
//  Copyright © 2019 Evolution. All rights reserved.
//

import Foundation

extension URLRequest {

    mutating func addJsonContentType() {
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    mutating func setBody(_ dictionary: [String: Any]) {
        self.httpBody = preparePostParameters(dictionary)
    }

    private func preparePostParameters(_ parameters: [String: Any]) -> Data {
        guard let encodedParameters = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        else {
            return Data()
        }

        return encodedParameters
    }
}
