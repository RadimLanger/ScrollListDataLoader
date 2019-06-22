//
//  HttpClient+Image.swift
//  
//

import UIKit

extension HttpClient {

    func downloadImage(
        for urlString: String,
        dispatchOnMainQueue: Bool = true,
        chacheEnabled: Bool = false,
        completion: @escaping ((String, UIImage?) -> Void)
    ) {
        guard let escapedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: escapedURLString)
        else {
            completion(urlString, nil)
            return
        }

        if chacheEnabled {
            if let image = loadImage(hash: escapedURLString.md5) {
                completion(urlString, image)
                return
            }
        }

        self.plainExecute(
            request: URLRequest(url: url),
            completion: { result in
                switch result {
                case .success(let response):
                    if 200..<299 ~= response.statusCode {
                        if let data = response.data {
                            let image = UIImage(data: data)

                            if chacheEnabled {
                                self.storeImage(hash: escapedURLString.md5, image: image)
                            }

                            if dispatchOnMainQueue == false {
                                return completion(urlString, image)
                            }

                            DispatchQueue.main.async {
                                return completion(urlString, image)
                            }
                        } else {
                            completion(urlString, nil)
                            return
                        }
                    } else {
                        completion(urlString, nil)
                        return
                    }
                case .failure:
                    completion(urlString, nil)
                    return
                }
        })
    }

    private func loadImage(hash: String?) -> UIImage? {
        guard let hash = hash else { return nil }

        let filePath = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(hash)
        guard let data = try? Data(contentsOf: filePath) else { return nil }

        return UIImage(data: data)
    }

    private func storeImage(hash: String?, image: UIImage?) {
        guard let hash = hash, let image = image else { return }

        let filePath = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(hash)
        try? image.pngData()?.write(to: filePath)
    }
}
