//
//  WebResponse.swift
//  WittySwift
//
//  Created by sudayn on 6/12/21.
//

import Foundation

class WebResponse {
    private var header: HTTPHeader!
    public var status: WebResponseStatus = .Ok
    var client: TCPClient!
    
    init(client: TCPClient) {
        self.client = client
    }
    
    func json(string: String) {
        self.header = HTTPHeader(contentLength: string.count, contentType: "application/json", responseStatus: status)
        let response = header.generate() + string
        let _ = client.send(string: response)
        client.close()
    }
    
    func html(string: String) {
        self.header = HTTPHeader(contentLength: string.count, contentType: "text/html", responseStatus: status)
        let response = header.generate() + string
        let _ = client.send(string: response)
        client.close()
    }
    
    func text(string: String) {
        self.header = HTTPHeader(contentLength: string.count, contentType: "text/plain", responseStatus: status)
        let response = header.generate() + string
        let _ = client.send(string: response)
        client.close()
    }
    
    func image(data: Data, ext: String) {
        self.header = HTTPHeader(contentLength: data.count, contentType: "image/\(ext)", responseStatus: status)
        let h = header.generate()
        let mutatingData = NSMutableData()
        let d = h.data(using: .utf8) ?? Data()
        mutatingData.append(d)
        mutatingData.append(data)
        let _ = client.send(data: mutatingData as Data)
        client.close()
    }
}
