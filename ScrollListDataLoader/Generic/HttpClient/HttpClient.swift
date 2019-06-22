//
//  HttpClient.swift
//

import Foundation

protocol HttpClient {

    func plainExecute(
        request: URLRequest,
        completion: @escaping ((Result<HttpClientResponse, HttpClientError>) -> Void)
    )

    func execute<StructResult: Decodable>(
        request: URLRequest,
        _ expectedType: StructResult.Type,
        completion: @escaping ((Result<StructResult, RequestExecutionError>) -> Void)
    )
}
