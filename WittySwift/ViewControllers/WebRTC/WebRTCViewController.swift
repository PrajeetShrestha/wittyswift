//
//  WebRTCViewController.swift
//  WittySwift
//
//  Created by sudayn on 6/10/21.
//

import UIKit
import WebRTC

struct RTCSessionDesc: Codable {
    var type: String
    var sdp: String
}

struct Payload: Codable {
    var sdp: RTCSessionDesc
}

enum PeerType {
    case Peer1
    case Peer2
}


class WebRTCViewController: UIViewController {

    @IBOutlet weak var pp2View: UIView!
    @IBOutlet weak var pp1View: UIView!
    private var peer1Connection: WebRTCClient!
    var server: WebServer!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializePeer1()
        if TARGET_OS_SIMULATOR != 0 {
            callServer()
        } else {
            startServer()
        }
    }
    
    private func startServer() {
        server = WebServer()
        server.start(port: 8080, handler: {(req, res) in
            if let data = req.body, let payload = try? JSONDecoder().decode(Payload.self, from: data) {
                self.peer1Connection.receiveOffer(offerSDP: RTCSessionDescription(type: .offer, sdp: payload.sdp.sdp), onCreateAnswer: {answer in
                    let answerPayload = Payload(sdp: RTCSessionDesc(type: "answer", sdp: answer.sdp))
                    if let json = try? JSONEncoder().encode(answerPayload) {
                        res.sendData(body: json, responseType: .Ok, contentType: "application/json")
                    }
                })
            } else {
                res.sendData(body: "{}", responseType: .NotFound, contentType: "application/json")
            }
        })
    }
    
    private func callServer() {
        peer1Connection.connect(onSuccess: {offer in
            self.callBroadcast(s: RTCSessionDesc(type: "offer", sdp: offer.sdp))
        })
    }
    
    func callBroadcast(s: RTCSessionDesc) {
        let urlSession = URLSession.shared
        var urlReq = URLRequest(url: URL(string: "http://192.165.10.67:8080")!)
        urlReq.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlReq.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Accept")
        urlReq.httpMethod = "POST"
        print(s.sdp)
        let jsonData = try? JSONSerialization.data(withJSONObject: Payload(sdp: s).dictionary)
        urlReq.httpBody = jsonData
        let task = urlSession.dataTask(with: urlReq, completionHandler: {(data, res, err) in
            guard err == nil else {
                print(err)
                return
            }
            
            if let json = try? JSONDecoder().decode(Payload.self, from: data!) {
                DispatchQueue.main.async {
                    guard self.peer1Connection != nil else {
                        print("webrtc is null in offer received")
                        return
                    }
                    print(json.sdp.sdp)
                    self.peer1Connection.receiveAnswer(answerSDP: RTCSessionDescription(type: .answer, sdp: json.sdp.sdp))
                }
            } else {
                print("parse error")
            }
        })
        task.resume()
    }
    
    // Me
    private func initializePeer1() {
        peer1Connection = WebRTCClient()
        if peer1Connection.isConnected {
            dismiss(animated: true, completion: nil)
            return
        }
        peer1Connection.delegate = self
        peer1Connection.setup(videoTrack: true, audioTrack: true, dataChannel: true, customFrameCapturer: false)
        peer1Connection.setupLocalViewFrame(frame: self.pp1View.bounds)
        //
        let localView = peer1Connection.localVideoView()
        localView.translatesAutoresizingMaskIntoConstraints = false
        self.pp1View.addSubview(localView)
        localView.leadingAnchor.constraint(equalTo: self.pp1View.leadingAnchor).isActive = true
        localView.trailingAnchor.constraint(equalTo: self.pp1View.trailingAnchor).isActive = true
        localView.bottomAnchor.constraint(equalTo: self.pp1View.bottomAnchor).isActive = true
        localView.topAnchor.constraint(equalTo: self.pp1View.topAnchor).isActive = true
    }
    
    
    func startCall() {
        peer1Connection.connect(onSuccess: {sdp in
            
        })
    }
}

extension WebRTCViewController: WebRTCClientDelegate {
    
    func didGenerateCandidate(iceCandidate: RTCIceCandidate) {
        
    }
    
    func didIceConnectionStateChanged(iceConnectionState: RTCIceConnectionState) {
        var state = ""
        switch iceConnectionState {
        case .checking:
            state = "checking..."
        case .closed:
            state = "closed"
        case .completed:
            state = "completed"
        case .connected:
            state = "connected"
        case .count:
            state = "count..."
        case .disconnected:
            state = "disconnected"
        case .failed:
            state = "failed"
        case .new:
            state = "new..."
        }
        print(state)
    }
    
    func didOpenDataChannel() {
        
    }
    
    func didReceiveData(data: Data) {
       
    }
    
    func didReceiveMessage(message: String) {
       
    }
    
    func didConnectWebRTC() {
       
    }
    
    func didDisconnectWebRTC() {
       
    }
    
    
}
