//
//  StaffModelData.swift
//  Playnxt
//
//  Created by CP on 08/06/22.
//

import Foundation

// MARK: - StaffPicks
struct StaffPicks: Codable {
    let status: Bool
    let data: StaffPicksData
    let message: String
}

// MARK: - DataClass
struct StaffPicksData: Codable {
    let capsul: [StaffPicksCapsul]
        let affiliateLink: String

        enum CodingKeys: String, CodingKey {
            case capsul
            case affiliateLink = "affiliate_link"
        }
}

// MARK: - Capsul
struct StaffPicksCapsul: Codable {
    let id: Int
        let image, title, capsulDescription: String
        let affiliation: String
        let userID, gameID, isDeleted: Int
        let createdAt, updatedAt: String

        enum CodingKeys: String, CodingKey {
            case id, image, title
            case capsulDescription = "description"
            case affiliation
            case userID = "user_id"
            case gameID = "game_id"
            case isDeleted = "is_deleted"
            case createdAt, updatedAt
        }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? -1
        image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""
        capsulDescription = try values.decodeIfPresent(String.self, forKey: .capsulDescription) ?? ""
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        affiliation = try values.decodeIfPresent(String.self, forKey: .affiliation) ?? ""
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        isDeleted = try values.decodeIfPresent( Int.self, forKey: .isDeleted) ?? -1
        userID = try values.decodeIfPresent( Int.self, forKey: .userID) ?? -1
        gameID = try values.decodeIfPresent( Int.self, forKey: .gameID) ?? -1
       
    }
}
