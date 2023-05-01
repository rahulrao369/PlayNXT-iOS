//
//  Model.swift
//  Playnxt
//
//  Created by cano on 31/05/22.
//

import Foundation

// MARK: - Register
// MARK: - Register
struct Register: Codable {
    let status: Bool
    let data: RegisterData
    let message: String
}

// MARK: - DataClass
struct RegisterData: Codable {
    let userID: Int
    let token: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case token
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        token = try values.decodeIfPresent(String.self, forKey: .token) ?? ""
    }
}
// MARK: - Login
struct Login: Codable {
    let status: Bool
    let data: LoginData
    let message: String
}
struct LoginData: Codable {
    let accountStatus, token: String
        let role, userID: Int

        enum CodingKeys: String, CodingKey {
            case accountStatus = "account_status"
            case token, role
            case userID = "user_id"
        }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID) ?? -1
        role = try values.decodeIfPresent(Int.self, forKey: .role) ?? -1
        token = try values.decodeIfPresent(String.self, forKey: .token) ?? ""
        accountStatus = try values.decodeIfPresent(String.self, forKey: .accountStatus) ?? ""
    }
}
