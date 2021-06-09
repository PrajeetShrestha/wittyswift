//
//  MessageCenterViewController.swift
//  PSArsenal
//
//  Created by Prajeet Shrestha on 20/05/2021.
//

import UIKit

class MessageCenterViewController: NavigationAwareViewController{
    
    @IBOutlet weak var lblMessageOne: UILabel!
    @IBOutlet weak var lblMessageTwo: UILabel!
    
    var tapCountPublisherOne:Int = 0
    var tapCountPublisherTwo:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMessageOne.text = "No message from publisher two."
        lblMessageTwo.text = "No message from publisher one."
        
        messageCenter.observe(name: .publisherOne) { [weak self] _ in
            guard let self = self else { return }
            self.tapCountPublisherOne += 1
            
            self.lblMessageTwo.text = "Message sent from publisher one: \(self.tapCountPublisherOne)"
        }
        
        messageCenter.observe(name: .publisherTwo) { [weak self] _ in
            guard let self = self else { return }
            self.tapCountPublisherTwo += 1
            self.lblMessageOne.text = "Message sent from publisher one: \(self.tapCountPublisherTwo)"
        }
        
    }
    
    @IBAction func tappedPublisherOne(_ sender: Any) {
        messageCenter.send(name: .publisherOne)
    }
    
    @IBAction func tappedPublisherTwo(_ sender: Any) {
        messageCenter.send(name: .publisherTwo)
    }
}
