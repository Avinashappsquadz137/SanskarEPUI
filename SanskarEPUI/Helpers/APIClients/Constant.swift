//
//  Constant.swift
//  Binko Movi
//
//  Created by Warln on 20/08/22.


import UIKit

class ApiRequest {
    static let shared = ApiRequest()
    
    enum BuildType {
        case dev
        case pro
    }
    
    struct Url {
        static var buildType: BuildType = .pro
        
        static var serverURL: String {
            switch buildType {
            case .dev:
                return "https://emp.sanskargroup.in/"
            case .pro:
                return "https://emp.sanskargroup.in/"
            }
        }
    }
}

struct Constant {

    static let BASEURL                     = ApiRequest.Url.serverURL

    static let getlogin                    = "api_panel/login_app"
    static let monthWiseDetailApi          = "api_panel/get_month_wise_emp_detail"
    static let eventDetail                 = "api_panel/event_detail"
}


