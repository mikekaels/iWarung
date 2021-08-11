//
//  UserDefault.swift
//  iWarung
//
//  Created by Santo Michael Sihombing on 12/08/21.
//

import UIKit

extension UserDefaults {
    
    private enum UserDefaultsKeys: String {
         case hasOnboarded
    }
    
    var hasOnboarded: Bool {
        get {
            bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
        
        set {
            setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
        }
    }
}
