//
//  MessageCenterViewController.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 20/05/2021.
//

import UIKit

fileprivate enum MessageCenterStrings:String {
    case noMessageOne = "No message from publisher one."
    case noMessageTwo = "No message from publisher two."
    case prefixOne = "Message sent from publisher one: "
    case prefixTwo = "Message sent from publisher two: "
}

class MessageCenterViewController: NavigationAwareViewController{
    
    @IBOutlet weak var lblMessageOne: UILabel!
    @IBOutlet weak var lblMessageTwo: UILabel!
    
    var tapCountPublisherOne:Int = 0
    var tapCountPublisherTwo:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMessageOne.text = MessageCenterStrings.noMessageTwo.rawValue
        lblMessageTwo.text = MessageCenterStrings.noMessageOne.rawValue
        
        messageCenter.observe(name: .publisherOne) { [weak self] _ in
            guard let self = self else { return }
            self.tapCountPublisherOne += 1
            self.lblMessageTwo.text = "\(MessageCenterStrings.prefixOne.rawValue)\(self.tapCountPublisherOne)"
        }
        
        messageCenter.observe(name: .publisherTwo) { [weak self] _ in
            guard let self = self else { return }
            self.tapCountPublisherTwo += 1
            self.lblMessageOne.text = "\(MessageCenterStrings.prefixTwo.rawValue)\(self.tapCountPublisherTwo)"
        }
    }
    
    @IBAction func tappedPublisherOne(_ sender: Any) {
        messageCenter.send(name: .publisherOne)
    }
    
    @IBAction func tappedPublisherTwo(_ sender: Any) {
        messageCenter.send(name: .publisherTwo)
    }
}
