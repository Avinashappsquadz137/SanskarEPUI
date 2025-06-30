//
//  TourBillingListModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 30/06/25.
//

import Foundation

struct TourBillingListModel : Codable {
    let status : Bool?
    let message : String?
    let data : [BillingList]?
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
        data = try values.decodeIfPresent([BillingList].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }

}

struct BillingList : Codable , Identifiable {
    var id: String { tourID ?? UUID().uuidString }
    let sno : Int?
    let empCode : String?
    let tourID : String?
    let amount : String?
    let approval_Amount : String?
    let hOD : String?
    let status : String?
    let creationOn : String?
    let date1 : String?
    let date2 : String?
    let location : String?
    let alldata : [String]?

    enum CodingKeys: String, CodingKey {

        case sno = "Sno"
        case empCode = "EmpCode"
        case tourID = "TourID"
        case amount = "Amount"
        case approval_Amount = "Approval_Amount"
        case hOD = "HOD"
        case status = "Status"
        case creationOn = "CreationOn"
        case date1 = "Date1"
        case date2 = "Date2"
        case location = "Location"
        case alldata = "alldata"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sno = try values.decodeIfPresent(Int.self, forKey: .sno)
        empCode = try values.decodeIfPresent(String.self, forKey: .empCode)
        tourID = try values.decodeIfPresent(String.self, forKey: .tourID)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        approval_Amount = try values.decodeIfPresent(String.self, forKey: .approval_Amount)
        hOD = try values.decodeIfPresent(String.self, forKey: .hOD)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        creationOn = try values.decodeIfPresent(String.self, forKey: .creationOn)
        date1 = try values.decodeIfPresent(String.self, forKey: .date1)
        date2 = try values.decodeIfPresent(String.self, forKey: .date2)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        alldata = try values.decodeIfPresent([String].self, forKey: .alldata)
    }

}
