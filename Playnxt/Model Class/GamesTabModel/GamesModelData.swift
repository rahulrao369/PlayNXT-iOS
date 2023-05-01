//
//  GamesModelData.swift
//  Playnxt
//
//  Created by CP on 08/06/22.
//

import Foundation
import SwiftUI

//MARK: - GetEventUser

// MARK: - GetEventUser
struct GetEventUser: Codable {
    let status: Bool
    let data: GetEventUserData
    let message: String
}

// MARK: - DataClass
struct GetEventUserData: Codable {
    let event: [GetEventUserEvent]
}

// MARK: - Event
struct GetEventUserEvent: Codable {
    let id, userID, isDeleted: Int
    let title, startDate, endDate, note: String
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case isDeleted = "is_deleted"
        case title
        case startDate = "start_date"
        case endDate = "end_date"
        case note, createdAt, updatedAt
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        isDeleted = try values.decodeIfPresent(Int.self, forKey: .isDeleted) ?? -1
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate) ?? ""
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate) ?? ""
        note = try values.decodeIfPresent(String.self, forKey: .note) ?? ""
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
    }
}

//MARK: - Add Event/Add Backlog / Add Wishlist

struct AddEvent:Codable {
    let status:Bool
    let message:String
}
// MARK: - GetMyBackLog
struct GetMyBackLog: Codable {
    let status: Bool
    let data: MyBacklogData
    let message: String
}
// MARK: - DataClass
struct MyBacklogData: Codable {
    let count: [Count]
    let backlogRemain: Int

        enum CodingKeys: String, CodingKey {
            case count
            case backlogRemain = "backlog_remain"
        }
}
// MARK: - Count
struct Count: Codable {
    let listName: String
    let totalGame,id: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case listName = "list_name"
        case totalGame = "total_game"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        listName = try values.decodeIfPresent(String.self, forKey: .listName) ?? ""
        totalGame = try values.decodeIfPresent(Int.self, forKey: .totalGame) ?? -1
    }
}

// MARK: - ViewMyGame
struct ViewMyGame: Codable {
    let status: Bool
    let data: MybacklogGame
    let message: String
}

// MARK: - DataClass
struct MybacklogGame: Codable {
    let games: [BacklogGame]
    let backlogRemain: Int

            enum CodingKeys: String, CodingKey {
                case games
                case backlogRemain = "backlog_remain"
            }
}

// MARK: - Game
struct BacklogGame: Codable {
    let id: Int
    let image, title, platform, genre: String
    let gameDescription,status,image_type: String
    
    enum CodingKeys: String, CodingKey {
        case id, image, title, platform, genre ,status,image_type
        case gameDescription = "description"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        platform = try values.decodeIfPresent(String.self, forKey: .platform) ?? ""
        genre = try values.decodeIfPresent(String.self, forKey: .genre) ?? ""
        gameDescription = try values.decodeIfPresent(String.self, forKey: .gameDescription) ?? ""
        status = try values.decode(String.self, forKey: .status)
        image_type = try values.decodeIfPresent(String.self, forKey: .image_type) ?? ""
    }
}

// MARK: - GetGameNote
struct GetGameNote: Codable {
    let status: Bool
    let data: GetGameNoteData
    let message: String
}

// MARK: - DataClass
struct GetGameNoteData: Codable {
    let capsul: [Capsul]
}

// MARK: - Capsul
struct Capsul: Codable {
    let noteID, gameID: Int
    let note, createOn: String
    
    enum CodingKeys: String, CodingKey {
        case noteID = "noteId"
        case gameID = "game_id"
        case note, createOn
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        noteID = try values.decodeIfPresent(Int.self, forKey: .noteID) ?? -1
        gameID = try values.decodeIfPresent(Int.self, forKey: .gameID) ?? -1
        note = try values.decodeIfPresent(String.self, forKey: .note) ?? ""
        createOn = try values.decodeIfPresent(String.self, forKey: .createOn) ?? ""
    }
}

// MARK: - GameCapsul
struct GameInfo: Codable {
    let status: Bool
    let data: GameInfoData
    let message: String
}

// MARK: - DataClass
struct GameInfoData: Codable {
    let capsul: GameInfoCapsul
}

// MARK: - Capsul
struct GameInfoCapsul: Codable {
    let gameID: Int
    let gImage, gTitle, gameStatus, platform: String
    let genre,image_type: String
    let rating: Double
    let capsulDescription: String
    
    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case gImage = "g_image"
        case gTitle = "g_title"
        case gameStatus = "game_status"
        case platform, genre, rating, image_type
        case capsulDescription = "description"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gameID = try values.decodeIfPresent(Int.self, forKey: .gameID) ?? -1
        gImage = try values.decodeIfPresent(String.self, forKey: .gImage) ?? ""
        gTitle = try values.decodeIfPresent(String.self, forKey: .gTitle) ?? ""
        gameStatus = try values.decodeIfPresent(String.self, forKey: .gameStatus) ?? ""
        platform = try values.decodeIfPresent(String.self, forKey: .platform) ?? ""
        genre = try values.decodeIfPresent(String.self, forKey: .genre) ?? ""
        capsulDescription = try values.decodeIfPresent(String.self, forKey: .capsulDescription) ?? ""
        image_type = try values.decodeIfPresent(String.self, forKey: .image_type) ?? ""
        rating = try values.decodeIfPresent(Double.self, forKey: .rating) ?? 0.0
        
    }
}

// MARK: - RecentGame
struct RecentGame: Codable {
    let status: Bool
    let data: RecentGameData
    let message: String
}

// MARK: - DataClass
struct RecentGameData: Codable {
    let capsul: [RecentGameCapsul]
    let wishCount, backlogCount,backlog_remaining: Int
    let active_plan,plan_type:String
    
    enum CodingKeys: String, CodingKey {
        case capsul
        case wishCount = "wish_count"
        case backlogCount = "backlog_count"
        case active_plan = "active_plan"
        case backlog_remaining = "backlog_remaining"
        case plan_type = "plan_type"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        wishCount = try values.decodeIfPresent(Int.self, forKey: .wishCount) ?? -1
        backlogCount = try values.decodeIfPresent(Int.self, forKey: .backlogCount) ?? -1
        capsul = try values.decodeIfPresent([RecentGameCapsul].self, forKey: .capsul) ?? [RecentGameCapsul]()
        active_plan = try values.decodeIfPresent(String.self, forKey: .active_plan) ?? ""
        backlog_remaining = try values.decodeIfPresent(Int.self, forKey: .backlog_remaining) ?? -1
        plan_type = try values.decodeIfPresent(String.self, forKey: .plan_type) ?? ""
    }
    
}

// MARK: - Capsul
struct RecentGameCapsul: Codable {
    let gameID: Int
    let gameImage, title, platform, genre: String
    let image_type: String
    
    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case gameImage = "game_image"
        case title, platform, genre
        case image_type
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gameID = try values.decodeIfPresent(Int.self, forKey: .gameID) ?? -1
        gameImage = try values.decodeIfPresent(String.self, forKey: .gameImage) ?? ""
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        platform = try values.decodeIfPresent(String.self, forKey: .platform) ?? ""
        genre = try values.decodeIfPresent(String.self, forKey: .genre) ?? ""
        image_type = try values.decodeIfPresent(String.self, forKey: .image_type) ?? ""
    }
}
// MARK: - FriendGameInfo
struct FriendGameInfo: Codable {
    let status: Bool
    let data: FriendGameInfoData
    let message: String
}

// MARK: - DataClass
struct FriendGameInfoData: Codable {
    let capsul: FriendGameInfoCapsul
    let actplan, activePlan: String
    enum CodingKeys: String, CodingKey {
        case capsul, actplan
        case activePlan = "active_plan"
    }
}
// MARK: - Capsul
struct FriendGameInfoCapsul: Codable {
    let gameID: Int
    let gImage, gTitle, platform, genre: String
    let capsulDescription,image_type: String
    let rating:Double
    
    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case gImage = "g_image"
        case gTitle = "g_title"
        case platform, genre
        case capsulDescription = "description"
        case rating
        case image_type
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gameID = try values.decodeIfPresent(Int.self, forKey: .gameID) ?? -1
        gImage = try values.decodeIfPresent(String.self, forKey: .gImage) ?? ""
        gTitle = try values.decodeIfPresent(String.self, forKey: .gTitle) ?? ""
        platform = try values.decodeIfPresent(String.self, forKey: .platform) ?? ""
        genre = try values.decodeIfPresent(String.self, forKey: .genre) ?? ""
        image_type = try values.decodeIfPresent(String.self, forKey: .image_type) ?? ""
        capsulDescription = try values.decodeIfPresent(String.self, forKey: .capsulDescription) ?? ""
        rating = try values.decodeIfPresent(Double.self, forKey: .rating) ?? 0.0
        
    }
}
// MARK: - PremiumPlan
struct PremiumResponse: Codable {
    let status: Bool
    let data: PremiumPlanData
    let message: String
}

// MARK: - DataClass
struct PremiumPlanData: Codable {
    let plan: [PremiumPlan]
}

// MARK: - Plan
struct PremiumPlan: Codable {
    let id: Int
    let type, duration, title: String
    let adFree, backlog, wishlist, calender: Int
    let personalStats, commActivity, followFriends, viewFriendBW: Int
    let messageFnd, scanningTool, accessNewFeatures, amount: Int
    let planDescription, createdAt, updatedAt: String
    
    
    enum CodingKeys: String, CodingKey {
        case id, type, duration, title
        case adFree = "ad_free"
        case backlog, wishlist, calender
        case personalStats = "personal_stats"
        case commActivity = "comm_activity"
        case followFriends = "follow_friends"
        case viewFriendBW
        case messageFnd = "message_fnd"
        case scanningTool = "scanning_tool"
        case accessNewFeatures = "access_new_features"
        case amount
        case planDescription = "description"
        case createdAt, updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        type = try values.decodeIfPresent(String.self, forKey: .type) ?? ""
        duration = try values.decodeIfPresent(String.self, forKey: .duration) ?? ""
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        adFree = try values.decodeIfPresent(Int.self, forKey: .adFree) ?? -1
        personalStats = try values.decodeIfPresent(Int.self, forKey: .personalStats) ?? -1
        commActivity = try values.decodeIfPresent(Int.self, forKey: .commActivity) ?? -1
        wishlist = try values.decodeIfPresent(Int.self, forKey: .wishlist) ?? -1
        backlog = try values.decodeIfPresent(Int.self, forKey: .backlog) ?? -1
        calender = try values.decodeIfPresent(Int.self, forKey: .calender) ?? -1
        followFriends = try values.decodeIfPresent(Int.self, forKey: .followFriends) ?? -1
        viewFriendBW = try values.decodeIfPresent(Int.self, forKey: .viewFriendBW) ?? -1
        messageFnd = try values.decodeIfPresent(Int.self, forKey: .messageFnd) ?? -1
        scanningTool = try values.decodeIfPresent(Int.self, forKey: .scanningTool) ?? -1
        accessNewFeatures = try values.decodeIfPresent(Int.self, forKey: .accessNewFeatures) ?? -1
        amount = try values.decodeIfPresent(Int.self, forKey: .amount) ?? -1
        planDescription = try values.decodeIfPresent(String.self, forKey: .planDescription) ?? ""
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        
    }
}


// MARK: - PremiumSubscriptionRespo
struct PremiumSubscriptionRespo: Codable {
    let status: Bool
    let data: PremiumSubscriptionData
    let message: String
}

// MARK: - DataClass
struct PremiumSubscriptionData: Codable {
    let plan: [PremiumSubscriptionPlan]
}

// MARK: - Plan
struct PremiumSubscriptionPlan: Codable {
    let id: Int
    let type: String
    let price, isDeleted: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, type, price
        case isDeleted = "is_deleted"
        case createdAt, updatedAt
    }
}

// MARK: - CheckSubsRespo
struct CheckSubsRespo: Codable {
    let status: Bool
    let data: CheckSubsData
    let message: String
}

// MARK: - DataClass
struct CheckSubsData: Codable {
    let freeBacklog: Int
       let subscribed: String
       let remainingDays: Int
       let subscription: CheckSubscription

       enum CodingKeys: String, CodingKey {
           case freeBacklog = "free_backlog"
           case subscribed
           case remainingDays = "remaining_days"
           case subscription
       }
}

// MARK: - Subscription
struct CheckSubscription: Codable {
    let id, userID, planID, amount: Int
        let startDate, endDate: String
        let graceTaken, recurring: Int
        let recurringPayment, type, status, createdAt: String
        let updatedAt: String

        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case planID = "plan_id"
            case amount
            case startDate = "start_date"
            case endDate = "end_date"
            case graceTaken = "grace_taken"
            case recurring
            case recurringPayment = "recurring_payment"
            case type, status, createdAt, updatedAt
        }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        type = try values.decodeIfPresent(String.self, forKey: .type) ?? ""
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate) ?? ""
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate) ?? ""
        amount = try values.decodeIfPresent(Int.self, forKey: .amount) ?? -1
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        graceTaken = try values.decodeIfPresent(Int.self, forKey: .graceTaken) ?? -1
        planID = try values.decodeIfPresent(Int.self, forKey: .planID) ?? -1
        recurring = try values.decodeIfPresent(Int.self, forKey: .recurring) ?? -1
        status = try values.decodeIfPresent(String.self, forKey: .status) ?? ""
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        recurringPayment = try values.decodeIfPresent(String.self, forKey: .recurringPayment) ?? ""
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
    }
}

// MARK: - ActivePlanRespo
struct ActivePlanRespo: Codable {
    let status: Bool
    let data: ActiveData
    let message: String
}

// MARK: - DataClass
struct ActiveData: Codable {
    let activePlan: ActivePlan

    enum CodingKeys: String, CodingKey {
        case activePlan = "active_plan"
    }
}

// MARK: - ActivePlan
struct ActivePlan: Codable {
    let title: String
    let amount: Int
    let startDate, endDate: String

    enum CodingKeys: String, CodingKey {
        case title, amount
        case startDate = "start_date"
        case endDate = "end_date"
    }
}


// MARK: - StatsResponse
struct StatsResponse: Codable {
    let status: Bool
    let data: StatsData
    let message: String
}

// MARK: - DataClass
struct StatsData: Codable {
    let totalgames, backlogcount, wishlistcount, ontheshelfcount: Int
    let rolledcreditcount, completedcount, currentplayingcount, takingbreakcount: Int
    let ratingtotal: Int
    let avgrate: Double
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalgames = try values.decodeIfPresent(Int.self, forKey: .totalgames) ?? -1
        backlogcount = try values.decodeIfPresent(Int.self, forKey: .backlogcount) ?? -1
        wishlistcount = try values.decodeIfPresent(Int.self, forKey: .wishlistcount) ?? -1
        ontheshelfcount = try values.decodeIfPresent(Int.self, forKey: .ontheshelfcount) ?? -1
        rolledcreditcount = try values.decodeIfPresent(Int.self, forKey: .rolledcreditcount) ?? -1
        completedcount = try values.decodeIfPresent(Int.self, forKey: .completedcount) ?? -1
        currentplayingcount = try values.decodeIfPresent(Int.self, forKey: .currentplayingcount) ?? -1
        takingbreakcount = try values.decodeIfPresent(Int.self, forKey: .takingbreakcount) ?? -1
        ratingtotal = try values.decodeIfPresent(Int.self, forKey: .ratingtotal) ?? -1
        avgrate = try values.decodeIfPresent(Double.self, forKey: .avgrate) ?? 0.0
    }
}

// MARK: - PaymentSummery
struct PaymentSummery: Codable {
    let status: Bool
    let data: DataClass
    let message: String
}

// MARK: - DataClass
struct DataClass: Codable {
    let actualprice, discount, finalprice: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        actualprice = try values.decodeIfPresent(String.self, forKey: .actualprice) ?? ""
        discount = try values.decodeIfPresent(String.self, forKey: .discount) ?? ""
        finalprice = try values.decodeIfPresent(String.self, forKey: .finalprice) ?? ""
    }
}
