//
//  HTTPHeader.swift
//  WittySwift
//
//  Created by sudayn on 6/12/21.
//

import Foundation

enum WebResponseStatus {
    case Ok
    case NotFound
}

enum WebHttpMethod {
    case GET
    case POST
}

struct HTTPHeader {
    public private(set) var contentLength: Int = 0
    public private(set) var contentType: String = ""
    public private(set) var responseType: WebResponseStatus = .Ok
    
    init(contentLength: Int, contentType: String, responseStatus: WebResponseStatus) {
        self.contentLength = contentLength
        self.contentType = contentType
        self.responseType = responseStatus
    }
    
    func generate() -> String {
        var header = "HTTP/1.1 200 OK"
        switch responseType {
        case .Ok:
            header = "HTTP/1.1 200 OK"
            
        default:
            header = "HTTP/1.1 404 Not Found"
        }
        let httpResponse: String = """
            Access-Control-Allow-Origin: *
            server: ios-server
            content-length: \(contentLength)
            content-type: \(contentType)\n\n
            """
        return header + "\n" + httpResponse
    }
}
