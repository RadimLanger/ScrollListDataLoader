//
//  RequestExecutionError.swift
//

enum RequestExecutionError: Error {
    case invalidResponse
    case invalidStatusCode
    case networkError
}
