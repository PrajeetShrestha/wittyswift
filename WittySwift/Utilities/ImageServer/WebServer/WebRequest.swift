//
//  WebRequest.swift
//  WittySwift
//
//  Created by sudayn on 6/12/21.
//

import Foundation

struct WebRequest {
    let method: String
    let version: String
    let path: String
    let params: Dictionary<String,String>?
    let body: Data?
    let accept: String
    let contentLength: Int
}
