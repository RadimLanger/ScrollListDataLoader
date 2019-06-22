//
//  HttpClientError.swift
//  

import Foundation

enum HttpClientError: Error {
    case dataTaskError(underlying: Error)
    case unknownError
}
