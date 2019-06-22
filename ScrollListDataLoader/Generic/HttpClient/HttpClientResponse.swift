//
//  HttpClientResponse.swift
//

import Foundation

struct HttpClientResponse {
    let statusCode: Int
    let data: Data?
}

extension HttpClientResponse {

    func parse<A: Decodable>() -> A? {
        guard let data = data else { return nil }

        let decodedData: A?
        let decoder = JSONDecoder()

        do {
            decodedData = try decoder.decode(A.self, from: data)
        } catch {
            decodedData = nil
            debugPrint("⚠️ Error parsing data: \(error)")
        }

        return decodedData
    }
}
