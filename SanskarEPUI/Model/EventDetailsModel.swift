//
//  EventDetailsModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 25/04/25.
//

import Foundation

struct EventDetailsModel : Codable {
    let data : [Events]?
    let message : String?
    let status : Bool?
    let error : [String]?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case message = "message"
        case status = "status"
        case error = "error"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([Events].self, forKey: .data)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct Events : Codable {
    let actionStatus : Int?
    let emp_Code : String?
    let bDay : String?
    let cntNo : String?
    var pImg : String?
    let leave_type : String?
    let event_type : String?
    let name : String?
    let dept : String?

    enum CodingKeys: String, CodingKey {

        case actionStatus = "actionStatus"
        case emp_Code = "Emp_Code"
        case bDay = "BDay"
        case cntNo = "CntNo"
        case pImg = "PImg"
        case leave_type = "leave_type"
        case event_type = "event_type"
        case name = "Name"
        case dept = "Dept"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        actionStatus = try values.decodeIfPresent(Int.self, forKey: .actionStatus)
        emp_Code = try values.decodeIfPresent(String.self, forKey: .emp_Code)
        bDay = try values.decodeIfPresent(String.self, forKey: .bDay)
        cntNo = try values.decodeIfPresent(String.self, forKey: .cntNo)
        pImg = try values.decodeIfPresent(String.self, forKey: .pImg)
        leave_type = try values.decodeIfPresent(String.self, forKey: .leave_type)
        event_type = try values.decodeIfPresent(String.self, forKey: .event_type)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        dept = try values.decodeIfPresent(String.self, forKey: .dept)
    }

}
