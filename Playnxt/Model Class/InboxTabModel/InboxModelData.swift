//
//  InboxModelData.swift
//  Playnxt
//
//  Created by CP on 08/06/22.
//

import Foundation

// MARK: - CommonResponse
struct CommonResponse: Codable {
    let status: Bool
    let message: String
}
// MARK: - ContactUs
struct ContactUs: Codable {
    let status: Bool
    let data: ContactUsData
    let message: String
}

// MARK: - DataClass
struct ContactUsData: Codable {
    let contactUs: String

    enum CodingKeys: String, CodingKey {
        case contactUs = "contact_us"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contactUs = try values.decodeIfPresent(String.self, forKey: .contactUs) ?? ""
    }
}
// MARK: - AboutUs
struct AboutUs: Codable {
    let status: Bool
    let data: AboutUsData
    let message: String
}

// MARK: - DataClass
struct AboutUsData: Codable {
    let aboutApp: String

    enum CodingKeys: String, CodingKey {
        case aboutApp = "about_app"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aboutApp = try values.decodeIfPresent(String.self, forKey: .aboutApp) ?? ""
    }
}
// MARK: - Suggestion
struct Suggestion: Codable {
    let status: Bool
    let data: SuggestionData
    let message: String
}

// MARK: - DataClass
struct SuggestionData: Codable {
    let suggest: Suggest
}

// MARK: - Suggest
struct Suggest: Codable {
    let id, userID: Int
    let text, updatedAt, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case text, updatedAt, createdAt
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? ""
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
    }
}

// MARK: - ChatListResponse
struct ChatListResponse: Codable {
    let status: Bool
    let data: ChatListData
    let message: String
}

// MARK: - DataClass
struct ChatListData: Codable {
    let inbox: [Inbox]
}

// MARK: - Inbox
struct Inbox: Codable {
    let image, name, message, time: String
    let id: Int
  
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        time = try values.decodeIfPresent(String.self, forKey: .time) ?? ""
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
    }
}


