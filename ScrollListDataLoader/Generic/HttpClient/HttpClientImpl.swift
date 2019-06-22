//
//  HttpClientImpl.swift
//

import Foundation

class HttpClientImpl: HttpClient {

    let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func plainExecute(
        request: URLRequest,
        completion: @escaping ((Result<HttpClientResponse, HttpClientError>) -> Void)
    ) {
        urlSession.dataTask(with: request) {(data, httpResponse, error) in
            guard let httpResponse = httpResponse as? HTTPURLResponse else {
                if let error = error {
                    completion(Result.failure(HttpClientError.dataTaskError(underlying: error)))
                } else {
                    completion(Result.failure(HttpClientError.unknownError))
                }
                return
            }
            let response = HttpClientResponse(statusCode: httpResponse.statusCode, data: data)
            completion(Result.success(response))
        }.resume()
    }

    func execute<StructResult: Decodable>(
        request: URLRequest,
        _ expectedType: StructResult.Type,
        completion: @escaping ((Result<StructResult, RequestExecutionError>) -> Void)
    ) {
        self.plainExecute(request: request) { result in
            switch result {
            case .success(let response):

                if let decoded: StructResult = response.parse() {
                    completion(.success(decoded))
                    return
                }

                if 200..<299 ~= response.statusCode {
                    completion(.failure(.invalidResponse))
                } else {
                    completion(.failure(.invalidStatusCode))
                }
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
}
