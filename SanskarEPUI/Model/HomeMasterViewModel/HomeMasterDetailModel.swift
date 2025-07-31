//
//  HomeMasterDetailModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/07/25.
//
import Foundation
struct HomeMasterDetailModel : Codable {
    let status : Bool?
    let message : String?
    let data : HomeMasterDetail?
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
        data = try values.decodeIfPresent(HomeMasterDetail.self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct HomeMasterDetail : Codable , Equatable{
    let pl_balance : String?
    let InTime : String?
    let OutTime : String?
    let notification_count : Int?

    enum CodingKeys: String, CodingKey {

        case pl_balance = "pl_balance"
        case InTime = "InTime"
        case OutTime = "OutTime"
        case notification_count = "notification_count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pl_balance = try values.decodeIfPresent(String.self, forKey: .pl_balance)
        InTime = try values.decodeIfPresent(String.self, forKey: .InTime)
        OutTime = try values.decodeIfPresent(String.self, forKey: .OutTime)
        notification_count = try values.decodeIfPresent(Int.self, forKey: .notification_count)
    }

}

