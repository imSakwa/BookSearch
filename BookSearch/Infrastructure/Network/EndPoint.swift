//
//  EndPoint.swift
//  BookSearch
//
//  Created by ChangMin on 2023/02/11.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var queryParameters: Encodable? { get }
    var bodyParameters: Encodable? { get }
    var headers: [String: String]? { get }
}

protocol Responsable {
    associatedtype Response
}

protocol RequesteResponsable: Requestable, Responsable {}

final class EndPoint<R>: RequesteResponsable {
    typealias Response = R
    
    var baseURL: String
    var path: String
    var method: HttpMethod
    var queryParameters: Encodable?
    var bodyParameters: Encodable?
    var headers: [String : String]?
    
    init(baseURL: String,
         path: String,
         method: HttpMethod,
         queryParameters: Encodable? = nil,
         bodyParameters: Encodable? = nil,
         headers: [String : String]? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.bodyParameters = bodyParameters
        self.headers = headers
    }
}

extension Requestable {
    func getURLRequest() throws -> URLRequest {
        let url = try url()
        var urlRequest = URLRequest(url: url)
        
        if let bodyParameters = try bodyParameters?.toDictionary() {
            if !bodyParameters.isEmpty {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters)
            }
        }
        
        urlRequest.httpMethod = method.rawValue
        headers?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        
        return urlRequest
    }
    
    func url() throws -> URL {
        let path = baseURL + path
        guard var urlComponents = URLComponents(string: path) else { throw NetworkError.needErrorControl }
        
        var queryItems = [URLQueryItem]()
        if let queryParameters = try queryParameters?.toDictionary() {
            queryParameters.forEach {
                queryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
            }
        }
        urlComponents.queryItems = queryItems.isEmpty ? nil : queryItems
        guard let url = urlComponents.url else { throw NetworkError.needErrorControl }
        return url
    }
}

extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any]
    }
}
