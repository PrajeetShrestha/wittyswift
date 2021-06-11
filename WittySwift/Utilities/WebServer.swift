//
//  WebServer.swift
//  TestProject
//
//  Created by sudayn on 1/20/21.
//

import Foundation
import Darwin.C

struct WebRequest {
    let params: String
    let body: Data?
    let contentType: String
}

struct WebResponse {
    
    enum WebResponseType {
        case Ok
        case NotFound
    }
    
    var client: Int32
    
    private func getResponse(contentLength: Int, responseType: WebResponseType, contentType: String) -> String {
        var header = "HTTP/1.1 200 OK"
        
        switch responseType {
        case .Ok:
            header = "HTTP/1.1 200 OK"
            
        default:
            header = "HTTP/1.1 404 Not Found"
        }
        
        let httpResponse: String = """
            server: ios-server
            content-length: \(contentLength)
            content-type: \(contentType)\n\n
            """
        
        return header + "\n" + httpResponse
    }
    
    func sendData(body: Data, responseType: WebResponseType, contentType: String) {
        let httpResponse: String = getResponse(contentLength: body.count, responseType: responseType, contentType: contentType)
        let data = NSMutableData()
        data.append(string: httpResponse)
        
        let toSend = data as Data
        
        toSend.withUnsafeBytes({pointer in
            let unsafeBufferPointer = pointer.bindMemory(to: UInt8.self)
            let unsafePointer = unsafeBufferPointer.baseAddress!
            
            Darwin.send(client, unsafePointer, toSend.count, 0)
            Darwin.close(client)
        })
    }
    
    func sendData(body: String, responseType: WebResponseType, contentType: String) {
        let httpResponse: String = getResponse(contentLength: body.count, responseType: responseType, contentType: contentType) + body
        
        httpResponse.withCString { bytes in
            send(client, bytes, Int(strlen(bytes)), 0)
            close(client)
        }
    }
}



class WebServer {
    
    private var sock: Int32!
    
    func start(port: Int, handler: @escaping (_ request: WebRequest,_ response: WebResponse) -> Void) {
        let queue = DispatchQueue.global(qos: .background)
        queue.async { [self] in
            let zero = Int8(0)
            let transportLayerType = SOCK_STREAM // TCP
            let internetLayerProtocol = AF_INET // IPv4
            self.sock = socket(internetLayerProtocol, Int32(transportLayerType), 0)
            let portNumber = UInt16(port)
            let socklen = UInt8(socklen_t(MemoryLayout<sockaddr_in>.size))
            var serveraddr = sockaddr_in()
            serveraddr.sin_family = sa_family_t(AF_INET)
            serveraddr.sin_port = in_port_t((portNumber << 8) + (portNumber >> 8))
            serveraddr.sin_addr = in_addr(s_addr: in_addr_t(0))
            serveraddr.sin_zero = (zero, zero, zero, zero, zero, zero, zero, zero)
            withUnsafePointer(to: &serveraddr) { sockaddrInPtr in
                let sockaddrPtr = UnsafeRawPointer(sockaddrInPtr).assumingMemoryBound(to: sockaddr.self)
                bind(self.sock, sockaddrPtr, socklen_t(socklen))
            }
            listen(self.sock, 40)
            print("Server listening on port \(portNumber)")
            
            repeat {
                let client = accept(self.sock, nil, nil)
                if client == -1 {
                    break
                }
//                let request = self.readData(client: client)
                let request = self.readData(sockHandle: client)
                let response = WebResponse(client: client)
                
                handler(request,response)
                
            } while self.sock > -1
        }
    }
    
    public func close(sock: Int32) {
        print("closing the server")
        Darwin.close(sock)
    }
    
    private func readData(sockHandle: Int32) -> WebRequest {
        // (1) received bytes in one cycle and numbers of cycles to receive
        // whole line (line delimited text)
        var received = 0
        var i = 0
        var eBuffer = [UInt8]()

        // (3) read from network until at least one \n is found
        repeat {
            var buffer = [UInt8](repeating: 0, count: 8)
            print("starting loop")
            received = read(sockHandle, &buffer, buffer.count)
            
            if received == 0 {
                print("no data")
                break
            }

            if received < 0 {
                print(String(cString: strerror(errno)))
                break
            }
            
            print(received)
            eBuffer.append(contentsOf: buffer)
            if received < buffer.count {
                print("Received Less buffer value")
                break
            }
            
            print("ending loop")
            
        } while received != 0
        print(String(bytes: eBuffer, encoding: .utf8))
        return readData(buffer: eBuffer)
    }
    
    private func readData(buffer: [UInt8]) -> WebRequest {
        
        let str = String(bytes: buffer, encoding: .utf8)
        let arr = str?.split(separator: "\r\n") ?? []
        var contentLength = 0
        var path = ""
        var contentType = ""
        var body: Data?
        
        
        
        arr.forEach({sub in
            let s = String(sub)
            
            if s.contains("/?") {
                let components = s.components(separatedBy: " ")
                path = components[1].replacingOccurrences(of: "/", with: "")
            }
            
            if s.contains("GET") {
                
            } else if s.contains("POST") {
                
            }
            
            if s.contains("Content-Length") {
                let components = s.components(separatedBy: ": ")
                if components.count == 2 {
                    contentLength = Int(components[1].trimmingCharacters(in: .whitespaces)) ?? 0
                }
            }
            
            
            if s.contains("Content-Type") {
                let components = s.components(separatedBy: ": ")
                if components.count == 2 {
                    contentType = components[1].trimmingCharacters(in: .whitespaces)
                }
            }
        })
        
        if let b = str?.components(separatedBy: "\r\n\r\n"), b.count == 2 {
            let raw = b[1]
            if raw.count >= contentLength {
                let r = String(raw[..<raw.index(raw.startIndex, offsetBy: contentLength)]).trimmingCharacters(in: .whitespacesAndNewlines)
                body = r.data(using: .utf8)
            }
            
        }
        return WebRequest(params: path,body: body, contentType: contentType)
    }
}

extension NSMutableData {
    func append(string: String) {
    let data = string.data(
        using: String.Encoding.utf8,
        allowLossyConversion: true)
    append(data!)
  }
}
