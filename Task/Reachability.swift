//
//  Reachability.swift
//  Task
//
//  Created by Hariharasudhan J on 22/02/22.
//

import Foundation
import  Reachability
class Reachabilityhelper {

    var firstTime : Bool?
    
      var delegate: ReachabilityDelegate?


    let reachability = try! Reachability()

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            self.delegate?.reachabilityChanged(isConnectionAVailable: true)
        case .cellular:
            self.delegate?.reachabilityChanged(isConnectionAVailable: false)
        case .unavailable:
            self.delegate?.reachabilityChanged(isConnectionAVailable: false)
        case .none:
            self.delegate?.reachabilityChanged(isConnectionAVailable: false)
        }
    }
    
    
    func deini() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    deinit {
        deini()
    }
    
}
protocol ReachabilityDelegate  {
    func reachabilityChanged(isConnectionAVailable:Bool)
}
