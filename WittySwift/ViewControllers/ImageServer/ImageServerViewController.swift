//
//  WebRTCViewController.swift
//  WittySwift
//
//  Created by sudayn on 6/10/21.
//

import UIKit
import Photos

class ImageServerViewController: UIViewController {


    @IBOutlet weak var linkLabel: UILabel!
    
    var server: WebServer!
    internal lazy var imageManager = PHImageManager.default()
    var allPhotos: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    var htmlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        server = WebServer()
        self.htmlString = fetchImageHtml()
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
          NSSortDescriptor(
            key: "creationDate",
            ascending: false)
        ]
        self.allPhotos = PHAsset.fetchAssets(with: fetchOptions)
        print("Found \(self.allPhotos.count) assets")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        linkLabel.text = "http://" + GetIpAddress() + ":8080/image"
        DispatchQueue.global().async {
            
            // Image Html Server
            self.server.get(path: "/image", handler: {(req, res) in
                res?.html(string: self.htmlString)
            })
            
            // API Server
            self.server.get(path: "/fetchImage", handler: {(req,res) in
                var images = [String]()
                guard self.allPhotos.count > 0 else {
                    res?.status = .NotFound
                    res?.json(string: "")
                    return
                }
                for i in 0..<self.allPhotos.count {
                    images.append("http://192.165.10.67:8080/photos?id=\(i)")
                }
                if let json = try? JSONSerialization.data(withJSONObject: images, options: .prettyPrinted) {
                    res?.json(string: String(data: json, encoding: .utf8) ?? "")
                } else {
                    res?.status = .NotFound
                    res?.json(string: "")
                }
            })
            
            // Photo server
            self.server.get(path: "/photos", handler: {(req,res) in
                print("get photos called")
                let id: Int = Int(req.params?["id"] ?? "0") ?? 0
                let hd: Bool = (req.params?["hd"] ?? "") == "true"
                let imageOption = PHImageRequestOptions()
                imageOption.resizeMode = .fast
                if hd {
                    imageOption.deliveryMode = .highQualityFormat
                } else {
                    imageOption.deliveryMode = .opportunistic
                }
                imageOption.isSynchronous = false
                guard self.allPhotos.count > 0 else {
                    res?.status = .NotFound
                    res?.json(string: "")
                    return
                }
                let p = self.allPhotos[id]
                self.imageManager.requestImage(for: p, targetSize: CGSize(width: 1280, height: 720), contentMode: .aspectFill, options: imageOption, resultHandler: {(image,info) in
                    let d = image?.pngData() ?? Data()
                    res?.image(data: d, ext: "png")
                })
            })
            
            // Run server at 8080
            self.server.run(port: 8080)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        server.stop()
    }
    
    
    func fetchImageHtml() -> String {
        if let path = Bundle.main.path(forResource: "image", ofType: "html") {
          do {
            return try String(contentsOfFile: path, encoding: .utf8).replacingOccurrences(of: "$(serverUrl)", with: GetIpAddress())
          } catch let error {
            print(error)
            return ""
          }
        }
        return ""
    }
    
    deinit {
        server.stop()
    }
}
