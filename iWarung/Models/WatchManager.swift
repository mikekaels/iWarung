//
//  WatchManager.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 23/08/21.
//

import Foundation
import WatchConnectivity

class WatchManager: NSObject {
    
    static let shared: WatchManager = WatchManager()
    
    fileprivate var session: WCSession?
    
    override init() {
        super.init()
        configureWatchKitSession()
    }
    
    func configureWatchKitSession() {
        if WCSession.isSupported() {//4.1
            session = WCSession.default//4.2
            session?.delegate = self//4.3
            session?.activate()//4.4
        }
    }
    
    func sendParamsToWatch(dict: [String: Any]) {
        do {
            try session?.updateApplicationContext(dict)
        } catch {
            print(error)
        }
    }
}

extension WatchManager: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session Inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Session Did Deactive")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session Did Complete")
    }
}
