//
//  HomeModel.swift
//  Playnxt
//
//  Created by CP on 08/06/22.
//

import Foundation
import CoreLocation


// MARK: - HomeResponse
struct HomeResponse: Codable {
    let status: Bool
    let data: HomeData
    let message: String
}
// MARK: - DataClass
struct HomeData: Codable {
    let profile: HomeProfile
    let following: [HomeFollowing]
    let totelFollowing: Int

    enum CodingKeys: String, CodingKey {
        case profile, following
        case totelFollowing = "totel_following"
    }
}
// MARK: - Following
struct HomeFollowing: Codable {
    let userID: Int
    let name, image: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name, image
    }
}
// MARK: - Profile
struct HomeProfile: Codable {
    let id: Int
    let name, image, email: String
}

// MARK: - GetMyProfile
struct GetMyProfile: Codable {
    let status: Bool
    let data: GetMyProfileData
    let message: String
}

struct GetMyProfileData: Codable {
    let profile: Profile
    let follower: [Follow]
    let following:[Following]
    let games: [Game]
    let totelFollower, totelFollowing, totelGame: Int

    enum CodingKeys: String, CodingKey {
        case profile, follower, following, games
        case totelFollower = "totel_follower"
        case totelFollowing = "totel_following"
        case totelGame = "totel_game"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        follower = try values.decodeIfPresent([Follow].self, forKey: .follower) ?? [Follow]()
        following = try values.decodeIfPresent([Following].self, forKey: .following) ?? [Following]()
        games = try values.decodeIfPresent([Game].self, forKey: .games) ?? [Game]()
        profile = try values.decodeIfPresent(Profile.self, forKey: .profile) ?? Profile(from: Profile.self as! Decoder)
        totelFollower = try values.decodeIfPresent(Int.self, forKey: .totelFollower) ?? -1
        totelFollowing = try values.decodeIfPresent(Int.self, forKey: .totelFollowing) ?? -1
        totelGame = try values.decodeIfPresent(Int.self, forKey: .totelGame) ?? -1
    }
}
struct Follow: Codable {
    let userID,mutual_friend,is_followed: Int
    let name, image: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name, image
        case mutual_friend = "mutual_friend"
        case is_followed = "is_followed"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        mutual_friend = try values.decodeIfPresent(Int.self, forKey: .mutual_friend) ?? -1
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        is_followed = try values.decodeIfPresent(Int.self, forKey: .is_followed) ?? -1
    }
}
struct Following: Codable {
    let userID,mutual_friend: Int
    let name, image: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name, image
        case mutual_friend = "mutual_friend"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        mutual_friend = try values.decodeIfPresent(Int.self, forKey: .mutual_friend) ?? -1
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
    }
}

// MARK: - AddGame
struct Game: Codable {
    let gameID: Int
    let image, title, gameDescription, genre: String
    let platform,image_type: String

    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case image, title
        case gameDescription = "description"
        case genre, platform, image_type
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gameID = try values.decodeIfPresent(Int.self, forKey: .gameID) ?? -1
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        gameDescription = try values.decodeIfPresent(String.self, forKey: .gameDescription) ?? ""
        genre = try values.decodeIfPresent(String.self, forKey: .genre) ?? ""
        platform = try values.decodeIfPresent(String.self, forKey: .platform) ?? ""
        image_type = try values.decodeIfPresent(String.self, forKey: .image_type) ?? ""
       
    }
}
// MARK: - Profile
struct Profile: Codable {
    let id: Int
    let name, image, email: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name, image, email
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
    }
}

// MARK: - GetcategoryList
struct GetcategoryListResponse: Codable {
    let status: Bool
    let data: CategoryListData
    let message: String
}
struct CategoryListData: Codable {
    let backlog: [Backlog]
    let wishlist: [Wishlist]
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        backlog = try values.decodeIfPresent([Backlog].self, forKey: .backlog) ?? [Backlog]()
        wishlist = try values.decodeIfPresent([Wishlist].self, forKey: .wishlist) ?? [Wishlist]()
    }
}
struct Backlog: Codable {
    let id: Int
    let name: String
    let isDeleted, userID: Int
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case isDeleted = "is_deleted"
        case userID = "user_id"
        case createdAt, updatedAt
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        isDeleted = try values.decodeIfPresent(Int.self, forKey: .isDeleted) ?? -1
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        
    }
}
struct Wishlist: Codable {
    let id: Int
    let name: String
    let userID, isDeleted: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case userID = "user_id"
        case isDeleted = "is_deleted"
        case createdAt, updatedAt
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        isDeleted = try values.decodeIfPresent(Int.self, forKey: .isDeleted) ?? -1
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        
    }
}

// MARK: - Search
struct Search: Codable {
    let status: Bool
    let data: SearchData
    let message: String
}

// MARK: - DataClass
struct SearchData: Codable {
    let profile: SearchProfile
    let info: [SearchInfo]
}

// MARK: - Info
struct SearchInfo: Codable {
    let userID: Int?
    let name: String?
    let image: String
    let gameID: Int?
    let title, infoDescription, genre, platform: String?
    let type:String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name, image
        case gameID = "game_id"
        case title
        case infoDescription = "description"
        case genre, platform
        case type
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        gameID = try values.decodeIfPresent(Int.self, forKey: .gameID) ?? -1
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        infoDescription = try values.decodeIfPresent(String.self, forKey: .infoDescription) ?? ""
        genre = try values.decodeIfPresent(String.self, forKey: .genre) ?? ""
        platform = try values.decodeIfPresent(String.self, forKey: .platform) ?? ""
        type = try values.decodeIfPresent(String.self, forKey: .type) ?? ""
    }
}

// MARK: - Profile
struct SearchProfile: Codable {
    let id: Int
    let name, image, email: String
    init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
    name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
    image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
    email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
}
}

// MARK: - SearchResponse
struct SearchResponse: Codable {
    let status: Bool
    let data: SearchResponseData
    let message: String
}

// MARK: - DataClass
struct SearchResponseData: Codable {
    let result: [SearchResult]
    let activePlan: String
      //  let totalBacklog: Int

        enum CodingKeys: String, CodingKey {
            case result
            case activePlan = "active_plan"
          //  case totalBacklog = "total_backlog"
        }
}

// MARK: - Result
struct SearchResult: Codable {
    let gameID: Int
    let image, title, resultDescription, genre: String
    let platform, type: String
    let id: Int
    let name, email, password: String
    let specialPriceNotification: Int
    let status,image_type: String
    let rememberToken: String
    let deviceToken, fcmToken: String
    let isDeleted, role: Int
    let createdAt, updatedAt: String
    let listName: String
    let totalGame: Int

    
    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case image, title
        case resultDescription = "description"
        case genre, platform, type
        case id, name, email, password
        case specialPriceNotification = "special_price_notification"
        case status,image_type
        case rememberToken = "remember_token"
        case deviceToken = "device_token"
        case fcmToken = "fcm_token"
        case isDeleted = "is_deleted"
        case listName = "list_name"
        case totalGame = "total_game"
        case role, createdAt, updatedAt
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gameID = try values.decodeIfPresent(Int.self, forKey: .gameID) ?? -1
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        resultDescription = try values.decodeIfPresent(String.self, forKey: .resultDescription) ?? ""
        genre = try values.decodeIfPresent(String.self, forKey: .genre) ?? ""
        platform = try values.decodeIfPresent(String.self, forKey: .platform) ?? "" 
        type = try values.decodeIfPresent(String.self, forKey: .type) ?? "user"
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        image_type = try values.decodeIfPresent(String.self, forKey: .image_type) ?? ""
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
        password = try values.decodeIfPresent(String.self, forKey: .password) ?? ""
        listName = try values.decodeIfPresent(String.self, forKey: .listName) ?? ""
        totalGame = try values.decodeIfPresent(Int.self, forKey: .totalGame) ?? -1
        specialPriceNotification = try values.decodeIfPresent(Int.self, forKey: .specialPriceNotification) ?? -1
        status = try values.decodeIfPresent(String.self, forKey: .status) ?? ""
        rememberToken = try values.decodeIfPresent(String.self, forKey: .rememberToken) ?? ""
        deviceToken = try values.decodeIfPresent(String.self, forKey: .deviceToken) ?? ""
        fcmToken = try values.decodeIfPresent(String.self, forKey: .fcmToken) ?? ""
        isDeleted = try values.decodeIfPresent(Int.self, forKey: .isDeleted) ?? -1
        role = try values.decodeIfPresent(Int.self, forKey: .role) ?? -1
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        
    }
}

// MARK: - Profile
struct SearchGameProfile: Codable {
    let id: Int
    let name, image, email: String
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        email = try values.decodeIfPresent(String.self, forKey: .email) ?? ""
    }
}

// MARK: - HomeButton
struct HomeButton: Codable {
    let status: Bool
    let data: HomeButtonData
    let presence: Int
    let message: String
}

// MARK: - DataClass
struct HomeButtonData: Codable {
    let gameID: Int
    let gImage, gTitle, gameStatus, platform: String
    let genre, dataDescription: String

    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case gImage = "g_image"
        case gTitle = "g_title"
        case gameStatus = "game_status"
        case platform, genre
        case dataDescription = "description"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gameID = try values.decodeIfPresent(Int.self, forKey: .gameID) ?? -1
        gImage = try values.decodeIfPresent(String.self, forKey: .gImage) ?? ""
        gTitle = try values.decodeIfPresent(String.self, forKey: .gTitle) ?? ""
        gameStatus = try values.decodeIfPresent(String.self, forKey: .gameStatus) ?? ""
        platform = try values.decodeIfPresent(String.self, forKey: .platform) ?? ""
        genre = try values.decodeIfPresent(String.self, forKey: .genre) ?? ""
        dataDescription = try values.decodeIfPresent(String.self, forKey: .dataDescription) ?? ""
    }
}

// MARK: - CheckPlan
struct CheckPlan: Codable {
    let status: Bool
    let data: CheckPlanData
    let message: String
}

// MARK: - DataClass
struct CheckPlanData: Codable {
    let actplan, activePlan: String
    let totalBacklog: Int

    enum CodingKeys: String, CodingKey {
        case actplan
        case activePlan = "active_plan"
        case totalBacklog = "total_backlog"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalBacklog = try values.decodeIfPresent(Int.self, forKey: .totalBacklog) ?? -1
        actplan = try values.decodeIfPresent(String.self, forKey: .actplan) ?? ""
        activePlan = try values.decodeIfPresent(String.self, forKey: .activePlan) ?? ""
    }
}


// MARK: - SearchAddGameResponse

struct SearchAddGameResponse: Codable {
    let status: Bool
    let data: SearchAddGameData
    let message: String
}

// MARK: - DataClass
struct SearchAddGameData: Codable {
    let newdata: [NewSearch]
}

// MARK: - Newdatum
struct NewSearch: Codable {
    let id: Int
       let image, title: String
       let platform: [String]
       let newdatumDescription: String
       let genre: [String]
       let type: String

       enum CodingKeys: String, CodingKey {
           case id, image, title, platform
           case newdatumDescription = "description"
           case  genre ,type
       }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        platform = try values.decodeIfPresent([String].self, forKey: .platform) ?? [String]()
        newdatumDescription = try values.decodeIfPresent(String.self, forKey: .newdatumDescription) ?? ""
        genre = try values.decodeIfPresent([String].self, forKey: .genre) ?? [String]()
        type = try values.decodeIfPresent(String.self, forKey: .type) ?? ""
    }
}

enum SearchGenre: String, Codable {
    case action = "action"
    case mind = "mind"
    case visualNovel = "Visual Novel"
}

enum SearchPlatform: String, Codable {
    case android = "Android "
    case iOS = "iOS"
    case platformAndroid = "Android"
    case webBrowser = "Web browser"
    case windowsPhone = "Windows Phone"
}




    //MARK: - Get Platform & genre

// MARK: - GetPlatformGenre
struct GetPlatformGenre: Codable {
    let status: Bool
    let data: GetPlatformData
    let message: String
}

// MARK: - DataClass
struct GetPlatformData: Codable {
    let genre: [GetGenre]
    let platform: [GetPlatform]
}

// MARK: - Genre
struct GetGenre: Codable {
    let id: Int
    let name: String
    let createdAt, updatedAt: AtedAtGenre
}

enum AtedAtGenre: String, Codable {
    case the20220917T094610000Z = "2022-09-17T09:46:10.000Z"
    case the20220917T094611000Z = "2022-09-17T09:46:11.000Z"
    case the20220917T095101000Z = "2022-09-17T09:51:01.000Z"
}

// MARK: - Platform
struct GetPlatform: Codable {
    let id: Int
    let name: String
    let createdAt, updatedAt: AtedAt
}

enum AtedAt: String, Codable {
    case the20220917T094610000Z = "2022-09-17T09:46:10.000Z"
    case the20220917T094611000Z = "2022-09-17T09:46:11.000Z"
    case the20220917T095101000Z = "2022-09-17T09:51:01.000Z"
}

