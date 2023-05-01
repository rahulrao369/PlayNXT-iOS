//
//  TokenClass.swift
//  Life Service
//
//  Created by cano on 27/01/22.
//

import Foundation

extension UserDefaults{

    // CREATE ENUM HAVING 1 STATE VALUE

    enum userDefaultKeys:String {
        case LoiginToken
       }

    // SAVE ACCESS TOKEN IN USER DEFAULTS

    func setAccessToken(id:String){
        set(id, forKey: userDefaultKeys.LoiginToken.rawValue)
        synchronize()
    }

// GET ACCESS TOKEN FROM USER DEFAULTS

    func getAccessToken()->String{

        return string(forKey: userDefaultKeys.LoiginToken.rawValue)!
    }
}
