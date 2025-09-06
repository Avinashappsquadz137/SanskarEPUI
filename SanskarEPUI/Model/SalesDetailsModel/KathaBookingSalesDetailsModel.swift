//
//  KathaBookingSalesDetailsModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 06/09/25.
//

import Foundation
struct KathaBookingSalesDetailsModel : Codable {
    let status : Bool?
    let message : String?
    let data : BookingSalesDetails?
    let error : [String]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(BookingSalesDetails.self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct BookingSalesDetails : Codable {
    let id : String?
    let name : String?
    let email : String?
    let phone : String?
    let role : String?
    let profileImage : String?
    let totalKathaBooked : Int?
    let kathaCompleted : Int?
    let kathaPending : Int?
    let totalAmount : Double?
    let amountReceived : Double?
    let amountPending : Double?
    let recentKathas : [RecentKathas]?
    let pagination : Pagination?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case role = "role"
        case profileImage = "profileImage"
        case totalKathaBooked = "totalKathaBooked"
        case kathaCompleted = "kathaCompleted"
        case kathaPending = "kathaPending"
        case totalAmount = "totalAmount"
        case amountReceived = "amountReceived"
        case amountPending = "amountPending"
        case recentKathas = "recentKathas"
        case pagination = "pagination"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        role = try values.decodeIfPresent(String.self, forKey: .role)
        profileImage = try values.decodeIfPresent(String.self, forKey: .profileImage)
        totalKathaBooked = try values.decodeIfPresent(Int.self, forKey: .totalKathaBooked)
        kathaCompleted = try values.decodeIfPresent(Int.self, forKey: .kathaCompleted)
        kathaPending = try values.decodeIfPresent(Int.self, forKey: .kathaPending)
        totalAmount = try values.decodeIfPresent(Double.self, forKey: .totalAmount)
        amountReceived = try values.decodeIfPresent(Double.self, forKey: .amountReceived)
        amountPending = try values.decodeIfPresent(Double.self, forKey: .amountPending)
        recentKathas = try values.decodeIfPresent([RecentKathas].self, forKey: .recentKathas)
        pagination = try values.decodeIfPresent(Pagination.self, forKey: .pagination)
    }

}

struct RecentKathas : Codable {
    let id : String?
    let kathaName : String?
    let date : String?
    let amount : Double?


    enum CodingKeys: String, CodingKey {

        case id = "id"
        case kathaName = "kathaName"
        case date = "date"
        case amount = "amount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        kathaName = try values.decodeIfPresent(String.self, forKey: .kathaName)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        amount = try values.decodeIfPresent(Double.self, forKey: .amount)
    }

}

struct Pagination : Codable {
    let page : Int?
    let perPage : Int?
    let totalPages : Int?

    enum CodingKeys: String, CodingKey {

        case page = "page"
        case perPage = "perPage"
        case totalPages = "totalPages"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let intPage = try? values.decodeIfPresent(Int.self, forKey: .page) {
            page = intPage
        } else if let strPage = try? values.decodeIfPresent(String.self, forKey: .page) {
            page = Int(strPage)
        } else {
            page = nil
        }
        perPage = try values.decodeIfPresent(Int.self, forKey: .perPage)
        totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
    }

}
