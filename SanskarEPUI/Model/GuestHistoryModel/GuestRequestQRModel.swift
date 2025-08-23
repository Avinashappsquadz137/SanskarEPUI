//
//  GuestRequestQRModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/08/25.
//
import Foundation
struct GuestRequestQRModel : Codable {
    let status : Bool?
    let message : String?
    let data : GuestRequestQR?
    let error : String?

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
        data = try values.decodeIfPresent(GuestRequestQR.self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
    }

}

struct GuestRequestQR : Codable {
    let qrcode : String?
    let qrthumbnail : String?

    enum CodingKeys: String, CodingKey {

        case qrcode = "qrcode"
        case qrthumbnail = "qrthumbnail"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        qrcode = try values.decodeIfPresent(String.self, forKey: .qrcode)
        qrthumbnail = try values.decodeIfPresent(String.self, forKey: .qrthumbnail)
    }

}

