//
//  ActivityModelData.swift
//  Playnxt
//
//  Created by CP on 08/06/22.
//

import Foundation

// MARK: - FriendList
struct FriendList: Codable {
    let status: Bool
    let data: FriendData
    let message: String
}

// MARK: - DataClass
struct FriendData: Codable {
    let capsul: [FriendCapsul]
}

// MARK: - Capsul
struct FriendCapsul: Codable {
    let userID: Int
    let userImg, userName,addedTime,title,listName: String
    let like,total_like: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userImg = "user_img"
        case userName = "user_name"
        case addedTime
        case title
        case listName
        case like,total_like
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        userImg = try values.decodeIfPresent(String.self, forKey: .userImg) ?? ""
        userName = try values.decodeIfPresent(String.self, forKey: .userName) ?? ""
        addedTime = try values.decodeIfPresent(String.self, forKey: .addedTime) ?? ""
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        listName = try values.decodeIfPresent(String.self, forKey: .listName) ?? ""
        like = try values.decodeIfPresent( Int.self, forKey: .like) ?? -1
        total_like = try values.decodeIfPresent(Int.self, forKey: .total_like) ?? -1
    }
}
// MARK: - Community
struct Community: Codable {
    let status: Bool
    let data: CommunityData
    let message: String
}

// MARK: - DataClass
struct CommunityData: Codable {
    let capsul: [CommunityCapsul]
}

// MARK: - Capsul
struct CommunityCapsul: Codable {
    let userID,total_like,like: Int
    let image, name,addedTime,title,listName: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case image, name
        case like,total_like
        case addedTime
        case title
        case listName
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        total_like = try values.decodeIfPresent(Int.self, forKey: .total_like) ?? -1
        like = try values.decodeIfPresent(Int.self, forKey: .like) ?? -1
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        addedTime = try values.decodeIfPresent(String.self, forKey: .addedTime) ?? ""
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        listName = try values.decodeIfPresent(String.self, forKey: .listName) ?? ""
    }
}
// MARK: - Follow
struct FollowUnfollow: Codable {
    let status: Bool
    let data: FollowData
    var message: String
}

// MARK: - DataClass
struct FollowData: Codable {
    let follower: Follower
}

// MARK: - Follower
struct Follower: Codable {
    let id, userID, followerID: Int
      let followDate, updatedAt, createdAt: String

      enum CodingKeys: String, CodingKey {
          case id
          case userID = "user_id"
          case followerID = "follower_id"
          case followDate = "follow_date"
          case updatedAt, createdAt
      }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        followerID = try values.decodeIfPresent(Int.self, forKey: .followerID) ?? -1
        followDate = try values.decodeIfPresent(String.self, forKey: .followDate) ?? ""
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        
    }
}

// MARK: - GetFriendProfile
struct GetFriendProfile: Codable {
    let status: Bool
    let data: FriendProfileData
    let message: String
}

// MARK: - DataClass
struct FriendProfileData: Codable {
    let profile: FriendProfile
    let follower:[FriendFollow]
    let following: [FriendFollowing]
    let games: [FriendGame]
    let totelFollower, totelFollowing, totelGame: Int

    enum CodingKeys: String, CodingKey {
        case profile, follower, following, games
        case totelFollower = "totel_follower"
        case totelFollowing = "totel_following"
        case totelGame = "totel_game"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        profile = try values.decodeIfPresent(FriendProfile.self, forKey: .profile)! 
        follower = try values.decodeIfPresent([FriendFollow].self, forKey: .follower) ?? [FriendFollow]()
        following = try values.decodeIfPresent([FriendFollowing].self, forKey: .following) ?? [FriendFollowing]()
        games = try values.decodeIfPresent([FriendGame].self, forKey: .games) ?? [FriendGame]()
        totelFollower = try values.decodeIfPresent(Int.self, forKey: .totelFollower) ?? -1
        totelFollowing = try values.decodeIfPresent(Int.self, forKey: .totelFollowing) ?? -1
        totelGame = try values.decodeIfPresent(Int.self, forKey: .totelGame) ?? -1
    }
}

// MARK: - Follow
struct FriendFollow: Codable {
    let userID: Int
      let name, image: String
      let mutualFriend, isFollow: Int

      enum CodingKeys: String, CodingKey {
          case userID = "user_id"
          case name, image
          case mutualFriend = "mutual_friend"
          case isFollow = "is_follow"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        mutualFriend = try values.decodeIfPresent(Int.self, forKey: .mutualFriend) ?? -1
        isFollow = try values.decodeIfPresent(Int.self, forKey: .isFollow) ?? -1
    }
}
struct FriendFollowing: Codable {
    let userID: Int
      let name, image: String
      let mutualFriend, isFollow: Int

      enum CodingKeys: String, CodingKey {
          case userID = "user_id"
          case name, image
          case mutualFriend = "mutual_friend"
          case isFollow = "is_follow"
      }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        mutualFriend = try values.decodeIfPresent(Int.self, forKey: .mutualFriend) ?? -1
        isFollow = try values.decodeIfPresent(Int.self, forKey: .isFollow) ?? -1
    }
}
// MARK: - Game
struct FriendGame: Codable {
    let gameID: Int
    let image, title, gameDescription, genre: String
    let platform: String

    enum CodingKeys: String, CodingKey {
        case gameID = "game_id"
        case image, title
        case gameDescription = "description"
        case genre, platform
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gameID = try values.decodeIfPresent(Int.self, forKey: .gameID) ?? -1
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        gameDescription = try values.decodeIfPresent(String.self, forKey: .gameDescription) ?? ""
        genre = try values.decodeIfPresent(String.self, forKey: .genre) ?? ""
        platform = try values.decodeIfPresent(String.self, forKey: .platform) ?? ""
        
    }
}

// MARK: - Profile
struct FriendProfile: Codable {
    let id: Int
    let name, image, email: String
}
