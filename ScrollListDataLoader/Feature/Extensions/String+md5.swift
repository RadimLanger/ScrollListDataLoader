//
//  String+md5.swift
//  Animefest
//

import Foundation
import CommonCrypto

extension String {

    var md5: String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)

        if let data = self.data(using: .utf8) {
            _ = data.withUnsafeBytes { body -> String in
                CC_MD5(body.baseAddress, CC_LONG(data.count), &digest)

                return ""
            }
        }

        return (0 ..< length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}
