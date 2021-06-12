//
//  WebServer.swift
//  TestProject
//
//  Created by sudayn on 1/20/21.
//

import Foundation

class WebServer {
    
    // MARK: - Properties
    typealias WebHandler = (WebRequest, WebResponse?) -> Void
    private var sock: Int32!
    private var server: TCPServer!
    private var isRunning: Bool = false
    private var getHandlers = [String: WebHandler]()
    private var postHandlers = [String: WebHandler]()
    
    // MARK: - Public Methods
    func get(path: String, handler: WebHandler?) {
        if let handler = handler {
            getHandlers[path] = handler
        }
    }
    
    func post(path: String, handler: WebHandler?) {
        if let handler = handler {
            postHandlers[path] = handler
        }
    }
    
    func run(port: Int) {
        server = TCPServer(address: GetIpAddress(), port: Int32(port))
        isRunning = true
        switch server.listen() {
        case .success:
            while isRunning {
                if let client = self.server.accept() {
                    print("connected to client \(client)")
                    let data = self.captureData(client: client)
                    let req = self.readData(str: String(data: data, encoding: .utf8) ?? "")
                    let response = WebResponse(client: client)
                    if req.method == "GET", let h = self.getHandlers[req.path] {
                        h(req, response)
                    } else if req.method == "POST", let h = self.postHandlers[req.path] {
                        h(req, response)
                    } else {
                        response.status = .NotFound
                        response.html(string: "")
                    }
                } else {
                    
                }
            }
        default:
            isRunning = false
            server.close()
            break
        }
    }
    
    func stop() {
        isRunning = false
        server.close()
    }
    
    // MARK: - PRIVATE METHODS
    private func captureData(client: TCPClient) -> Data {
        let bufferSize = 64
        let mutableData = NSMutableData()
        while true {
            print("looping")
            let readData = client.read(bufferSize, handler: {byte in
                let d = Data(bytes: byte ?? [], count: byte?.count ?? 0)
                mutableData.append(d)
            })
            print("ReadDataLen: \(readData)")
            if readData < bufferSize {
                break
            }
        }
        return mutableData as Data
    }
    
    private func readData(str: String) -> WebRequest {
        let arr = str.split(separator: "\r\n")
        var contentLength = 0
        var path = ""
        var contentType = ""
        var body: Data?
        var version: String = ""
        var method: String = ""
        var params: Dictionary<String,String>?
        
        arr.enumerated().forEach({(i,sub) in
            let s = String(sub)
            if i == 0 {
                let parts = s.components(separatedBy: " ")
                if parts.count == 3 {
                    method = parts[0]
                    let p = parts[1].components(separatedBy: "?")
                    path = p[0]
                    if p.count == 2 {
                        params = Dictionary<String, String>()
                        let paramString = p[1]
                        let kv = paramString.components(separatedBy: "&")
                        kv.forEach({kvStr in
                            if kvStr.contains("=") {
                                let kvPairs = kvStr.components(separatedBy: "=")
                                if kvPairs.count == 2 {
                                    params?[kvPairs[0]] = kvPairs[1]
                                }
                            }
                        })
                    }
                    version = parts[2]
                }
            }
            
            if s.contains("Content-Length") {
                let components = s.components(separatedBy: ": ")
                if components.count == 2 {
                    contentLength = Int(components[1].trimmingCharacters(in: .whitespaces)) ?? 0
                }
            }
            
            
            if s.contains("Accept:") {
                let components = s.components(separatedBy: ": ")
                if components.count == 2 {
                    contentType = components[1].trimmingCharacters(in: .whitespaces)
                }
            }
        })
        
        if method != "GET" {
            let b = str.components(separatedBy: "\r\n\r\n")
            if b.count == 2 {
                let raw = b[1]
                if raw.count >= contentLength {
                    let r = String(raw[..<raw.index(raw.startIndex, offsetBy: contentLength)]).trimmingCharacters(in: .whitespacesAndNewlines)
                    body = r.data(using: .utf8)
                }
            }
            
        }
        return WebRequest(method: method, version: version, path: path, params: params, body: body, accept: contentType, contentLength: contentLength)
    }
}
