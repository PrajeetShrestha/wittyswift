//
//  IpAdress.swift
//  WittySwift
//
//  Created by sudayn on 6/12/21.
//

import Foundation

@_silgen_name("getIpAddress") private func getIpAddress(ip: UnsafePointer<Byte>)

func GetIpAddress() -> String {
    var byte = [Byte](repeating: 0, count: 20)
    getIpAddress(ip: &byte)
    let d = Data(bytes: byte, count: byte.count)
    return String(data: d, encoding: .utf8)?.replacingOccurrences(of: "\0", with: "") ?? ""
}
