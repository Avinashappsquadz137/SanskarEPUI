//
//  MasterListSearchModel.swift
//  SanskarEPUI
//
//  Created by Avinash Gupta on 22/08/25.
//

import Foundation
struct MasterListSearchModel : Codable {
    let status : Bool?
    let message : String?
    let data : [MasterListSearch]?
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
        data = try values.decodeIfPresent([MasterListSearch].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct MasterListSearch : Codable {
    let empCode : String?
    let name : String?
    let dept : String?
    let emailID : String?
    let mobile : String?
    let extn : String?
    let designation : String?
    let pLBalance : String?
    let pendingLeave : String?
    let rejectLeave : String?
    let approveLeave : String?
    let pImgUrl : String?

    enum CodingKeys: String, CodingKey {

        case empCode = "EmpCode"
        case name = "Name"
        case dept = "Dept"
        case emailID = "EmailID"
        case mobile = "Mobile"
        case extn = "Extn"
        case designation = "Designation"
        case pLBalance = "PL Balance"
        case pendingLeave = "Pending Leave"
        case rejectLeave = "Reject Leave"
        case approveLeave = "Approve Leave"
        case pImgUrl = "PImgUrl"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        empCode = try values.decodeIfPresent(String.self, forKey: .empCode)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        dept = try values.decodeIfPresent(String.self, forKey: .dept)
        emailID = try values.decodeIfPresent(String.self, forKey: .emailID)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        extn = try values.decodeIfPresent(String.self, forKey: .extn)
        designation = try values.decodeIfPresent(String.self, forKey: .designation)
        pLBalance = try values.decodeIfPresent(String.self, forKey: .pLBalance)
        pendingLeave = try values.decodeIfPresent(String.self, forKey: .pendingLeave)
        rejectLeave = try values.decodeIfPresent(String.self, forKey: .rejectLeave)
        approveLeave = try values.decodeIfPresent(String.self, forKey: .approveLeave)
        pImgUrl = try values.decodeIfPresent(String.self, forKey: .pImgUrl)
    }

}
