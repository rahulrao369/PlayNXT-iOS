//
//  Constant.swift
//  Playnxt
//
//  Created by cano on 31/05/22.
//

import Foundation
import  UIKit
import IQKeyboardManagerSwift

class Constant {
    
    static let appControllerManger = (UIApplication.shared.delegate as! AppDelegate)
    static let appDelegate         = UIApplication.shared.delegate as! AppDelegate
    
    
    static var BaseUrl         = "https://playnxt.app/playnext"
    static let ImageUrl        = "https://playnxt.app/playnext"
    
    static let banner_UnitId   = "ca-app-pub-2864521706832933/6786995232"
    
    // test unit id :-  "ca-app-pub-3940256099942544/2934735716"
    
    static let Token = ""
    //MARK:- UserDefults
    
    static let AutoLogin = ""
    static let Login_Response = ""
    
    struct URL_CONSTANT {
        
        static let Register                    = BaseUrl + "/register"
        static let Login                       = BaseUrl + "/login"
        static let Resend_email                = BaseUrl + "/resend-mail"
        static let Get_Event                   = BaseUrl + "/users/get-event"
        static let Add_Event                   = BaseUrl + "/users/add-event"
        static let Get_My_Profile              = BaseUrl + "/users/get-my-profile"
        static let Get_My_Backlog              = BaseUrl + "/users/get-my-backloglist"
        static let Add_BackLog_List            = BaseUrl + "/users/add-backloglist"
        static let Add_Wishlist                = BaseUrl + "/users/add-wishlist"
        static let Get_My_Wishlist             = BaseUrl + "/users/get-my-wishlist"
        static let Add_Game                    = BaseUrl + "/users/add-game"
        static let Change_password             = BaseUrl + "/users/change-pass"
        static let Category_List               = BaseUrl + "/users/category-name"
        static let Edit_Profile                = BaseUrl + "/users/edit-profile"
        static let Edit_BacklogList            = BaseUrl + "/users/edit-backloglist"
        static let Edit_WishList               = BaseUrl + "/users/edit-wishlist"
        static let Get_category_List           = BaseUrl + "/users/category-name"
        static let Delete_Backlog_Wishlist     = BaseUrl + "/users/delete-list"
        static let View_my_backlogGame         = BaseUrl + "/users/view-my-BackLoggame"
        static let View_My_wishlistGame        = BaseUrl + "/users/view-my-Wishlistgame"
        static let Delete_Account              = BaseUrl + "/users/delete-account"
        static let Add_Note                    = BaseUrl + "/users/add-note"
        static let Get_gameNote                = BaseUrl + "/users/get-gamenote"
        static let Edit_Game_Note              = BaseUrl + "/users/edit-game-note"
        static let Delete_Game_Note            = BaseUrl + "/users/delete-game-note"
        static let Add_Game_Status             = BaseUrl + "/users/add-game-status"
        static let Game_Info                   = BaseUrl + "/users/game-info"
        static let Delete_Game                 = BaseUrl + "/users/delete-game"
        static let Get_Friend_List             = BaseUrl + "/users/get-my-friendList"
        static let Like_Unlike                 = BaseUrl + "/users/like-and-unlike"
        static let Community_List              = BaseUrl + "/users/community"
        static let follow_Add_Friend           = BaseUrl + "/users/follow-friend"
        static let Get_Friend_Profile          = BaseUrl + "/users/get-friend-profile"
        static let Edit_Event                  = BaseUrl + "/users/edit-event"
        static let Delete_Event                = BaseUrl + "/users/delete-event"
        static let Recent_Game                 = BaseUrl + "/users/recent-game"
        static let Logout                      = BaseUrl + "/users/logout"
        static let Unfollow                    = BaseUrl + "/users/unfollow-friend"
        static let Home                        = BaseUrl + "/users/home"
        static let Contact_US                  = BaseUrl + "/users/contact-us"
        static let About_us                    = BaseUrl + "/users/about-app"
        static let Suggest_new_feature         = BaseUrl + "/users/suggest-new-feature"
        static let Search                      = BaseUrl + "/users/search"
        static let Home_Button                 = BaseUrl + "/users/homeButton"
        static let Staff_picks                 = BaseUrl + "/users/staff-picks"
        static let Add_Friend_Game             = BaseUrl + "/users/add-friend-game"
        static let Forgot_Password             = BaseUrl + "/users/forget-password"
        static let Premium_Plan                = BaseUrl + "/users/plans"
        static let Cupon_Summery               = BaseUrl + "/users/get-payment-summery"
        static let Purchase_Plan               = BaseUrl + "/users/purchase-plan"
        static let Chat_List                   = BaseUrl + "/users/chatlist"
        static let My_Active_Plan              = BaseUrl + "/users/myactiveplan"
        static let Free_Plan                   = BaseUrl + "/users/free-plan"
        static let Check_Subscription          = BaseUrl + "/users/check-subscription"
        static let Search_AddGame              = BaseUrl + "/users/get-game-by-filter"
        static let Get_PlatformGenre           = BaseUrl + "/users/get-platform-genre"
        static let Stats                       = BaseUrl + "/users/get-stat"
        static let CANCEL_SUBSCRIPTION         = BaseUrl + "/users/cancel-subscription"
        
    }
    struct Const {
        static let Device_Token         = Token + "token"
    }
}
