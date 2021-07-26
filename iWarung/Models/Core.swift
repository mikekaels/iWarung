//
//  Core.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 27/07/21.
//

import CoreData

class Core {
    static let shared = Core()
    
    func isNewUser()-> Bool {
        return UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}

