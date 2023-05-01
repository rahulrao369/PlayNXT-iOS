//
//  Structure.swift
//  Playnxt
//
//  Created by cano on 20/05/22.
//

import Foundation
import UIKit

struct GameDetail {
    
    var name : String
    var image : String
    
    init (name:String,img:String)
    {
        self.name = name
        self.image = img
    }
}
//MARK:-
struct FriendsImage {
    var image : String
    
    init (img:String)
    {
        self.image = img
    }
}
//MARK:-

struct Premium {
    
    var name : String
    var prim : String
    var nonPrim : String
    var image : String
    var rightImg :String
    
    init (name:String,img:String,non:String,prim:String,imgRight:String)
    {
        self.name = name
        self.image = img
        self.nonPrim = non
        self.prim = prim
        self.rightImg = imgRight
    }
}
//MARK:-

struct Status {
    
    var name : String
    var perc1 : String
    var perc2 : String
   
    
    init (name:String,num1:String,num2:String)
    {
        self.name = name
        self.perc1 = num1
        self.perc2 = num2
    }
}

//MARK:-

struct Plan {
    
    var planName : String
    var planIcon : String
    var imgDash : String
    init (planName:String,planIcon:String,imgDash:String)
    {
        self.planName = planName
        self.planIcon = planIcon
        self.imgDash = imgDash
        
    }
}
