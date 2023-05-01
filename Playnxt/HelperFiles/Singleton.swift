//
//  Singleton.swift
//  Playnxt
//
//  Created by CP on 07/06/22.
//

import Foundation
import UIKit

class Singleton {
    static let sharedInstance = Singleton()
 
    var lat:String?
    var long:String?
    var list_Name:String?
    var List_id:Int?
    var category_type:String?
    var frndUserID:Int?
    var response:String?
    var homeResponse:String?
    var profileImg:String?
    var gameName:String?
    var gameRating:Double?
    var reciver_id:Int?
    var pass_status:String?
    var remaning:Int?
}
