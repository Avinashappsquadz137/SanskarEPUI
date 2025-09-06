//
//  SalesDetailsListModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 06/09/25.
//

import Foundation
struct SalesDetailsListModel : Codable {
    
    let status : Bool?
    let message : String?
    let data : [SalesDetailsList]?
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
        data = try values.decodeIfPresent([SalesDetailsList].self, forKey: .data)
        error = try values.decodeIfPresent([String].self, forKey: .error)
    }
    
}

struct SalesDetailsList : Codable , Identifiable {
    var id: String { empCode ?? UUID().uuidString }
    let name : String?
    let empCode : String?
    let dept : String?
    let empImage : String?
    let designation : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case empCode = "empCode"
        case dept = "dept"
        case empImage = "PImg"
        case designation = "designation"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        empCode = try values.decodeIfPresent(String.self, forKey: .empCode)
        dept = try values.decodeIfPresent(String.self, forKey: .dept)
        empImage = try values.decodeIfPresent(String.self, forKey: .empImage)
        designation = try values.decodeIfPresent(String.self, forKey: .designation)
    }

}
