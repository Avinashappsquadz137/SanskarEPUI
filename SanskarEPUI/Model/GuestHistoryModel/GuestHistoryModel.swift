//
//  GuestHistoryModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 06/05/25.
//

import Foundation

struct GuestHistoryModel : Codable {
    let status : Bool?
    let message : String?
    let data : [GuestHistory]?
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
        data = try values.decodeIfPresent([GuestHistory].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}


struct GuestHistory : Codable {
    let id : String?
    let name : String?
    let in_time : String?
    let out_time : String?
    let reason : String?
    let guest_date : String?
    let address : String?
    let mobile : String?
    let image : String?
    let reqdate : String?
    let to_whome : String?
    let type : Int?
    let qrcode : String?
    let qrthumbnail : String?
    let guestURL : String?
    let isEdit: Bool
    let isCancel: Bool
    let arrival_time : String?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case isEdit = "isEdit"
        case isCancel = "isCancel"
        case arrival_time = "arrival_time"
        case name = "name"
        case in_time = "in_time"
        case out_time = "out_time"
        case reason = "reason"
        case guest_date = "guest_date"
        case address = "address"
        case mobile = "mobile"
        case image = "image"
        case reqdate = "reqdate"
        case to_whome = "to_whome"
        case type = "type"
        case qrthumbnail = "qrthumbnail"
        case qrcode = "qrcode"
        case guestURL = "guestURL"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        isEdit = try values.decodeIfPresent(Bool.self, forKey: .isEdit) ?? false
        isCancel = try values.decodeIfPresent(Bool.self, forKey: .isCancel) ?? false
        name = try values.decodeIfPresent(String.self, forKey: .name)
        arrival_time = try values.decodeIfPresent(String.self, forKey: .arrival_time)
        in_time = try values.decodeIfPresent(String.self, forKey: .in_time)
        out_time = try values.decodeIfPresent(String.self, forKey: .out_time)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        guest_date = try values.decodeIfPresent(String.self, forKey: .guest_date)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        reqdate = try values.decodeIfPresent(String.self, forKey: .reqdate)
        to_whome = try values.decodeIfPresent(String.self, forKey: .to_whome)
        qrthumbnail = try values.decodeIfPresent(String.self, forKey: .qrthumbnail)
        type = try values.decodeIfPresent(Int.self, forKey: .type)
        qrcode = try values.decodeIfPresent(String.self, forKey: .qrcode)
        guestURL = try values.decodeIfPresent(String.self, forKey: .guestURL)
    }

}
