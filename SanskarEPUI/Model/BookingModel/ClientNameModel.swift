//
//  ClientNameModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 16/08/25.
//
import Foundation
struct ClientNameModel : Codable {
    let status : Bool?
    let message : String?
    let data : [ClientName]?
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
        data = try values.decodeIfPresent([ClientName].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct ClientName : Codable {
    let name : String?
    let address : String?
    let pancard : String?
    let gst_no : String?
    let client_id : Int?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case address = "address"
        case pancard = "pancard"
        case gst_no = "gst_no"
        case client_id = "client_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        pancard = try values.decodeIfPresent(String.self, forKey: .pancard)
        gst_no = try values.decodeIfPresent(String.self, forKey: .gst_no)
        client_id = try values.decodeIfPresent(Int.self, forKey: .client_id)
    }

}
