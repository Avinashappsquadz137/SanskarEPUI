////
////
////  APICaller.swift
////  Binko Movi
////
////  Created by Warln on 19/08/22.
////
//
//import Alamofire
//import UIKit
//
//
//// MARK: - Welcome
//struct ErrorHandler: Codable {
//    let error, message: String?
//    let status: Bool?
//}
//enum HTTPMethod1 {
//    case post
//    case get
//    case put
//
//    func toAlamofireMethod() -> Alamofire.HTTPMethod {
//        switch self {
//        case .post: return .post
//        case .get: return .get
//        case .put: return .put
//        }
//    }
//}
//
//class APICaller {
//    static let shared = APICaller()
//
//    private init() {}
//    enum ApiError: Error {
//        case failedToGetData
//    }
//
//    func dictionaryToJSON(dictionary: [String: Any]) -> String {
//        if let theJSONData = try? JSONSerialization.data(
//            withJSONObject: dictionary,
//            options: .prettyPrinted
//        ),
//            let theJSONText = String(data: theJSONData,
//                                     encoding: String.Encoding.ascii) {
//            return "\(theJSONText)"
//        }
//        return "N/A"
//    }
//
//   
//
//    class func getFullPath(path: String) -> String {
//        var fullPath: String = Constant.BASEURL
//        fullPath.append(path)
//        return fullPath
//    }
//
//    public func json(from object: AnyObject) -> String? {
//        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
//            return nil
//        }
//        return String(data: data, encoding: String.Encoding.utf8)
//    }
//
//    public func apiCall(post: Dictionary<String, Any>, url: String, completionHandler: @escaping responseHandler) {
//        print("Request URL ->   \(url)")
//        print("Request parameter ->   \(post.jsonStringRepresentation?.description ?? "")")
//        NotificationCenter.default.post(name: NSNotification.Name("secureScreen"),
//                                        object: nil)
//
//        AF.upload(multipartFormData: { [self] multipartFormData in
//            for (key, value) in post {
//                if value is NSArray {
//                    let str = json(from: value as AnyObject)
//                    multipartFormData.append((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                } else {
//                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                }
//            }
//        }, to: url, method: .post, headers: nil)
//            .response { response in
//                debugPrint(response)
//                if let responseData = response.response {
//                    if responseData.statusCode == 200 {
//                        switch response.result {
//                        case let .success(data):
//                            completionHandler(true, [:], nil, data)
//                        case let .failure(error):
//                            completionHandler(false, [:], error as NSError?, nil)
//                        }
//                    }
//                }
//            }
//    }
//
//    public func apiCallPostWithOutFormData(_ apiName: String, _ param: [String: Any], header : HTTPHeaders = [], completionHandler: @escaping responseHandler) {
//        let path: String = APICaller.getFullPath(path: apiName).trimmingCharacters(in: .whitespacesAndNewlines)
//        AF.request(path, method: .post, parameters: param, encoding: JSONEncoding.default, headers: header.count > 0 ? header : APICaller.setHeader())
//            .response { response in
//                self.convertDataToJSON(path, param, response.data)
//                switch response.result {
//                    case .success(let data):
//                        completionHandler(true, [:], nil, data)
//                    case .failure(let error):
//                        completionHandler(false, [:], error as NSError?, nil)
//                }
//            }
//    }
//    
//    
//    public func uploadApiCallPostWithOutFormData(_ apiName: String, _ param: [[String: Any]], header : HTTPHeaders = [], completionHandler: @escaping responseHandler) {
//        let path: String = APICaller.getFullPath(path: apiName).trimmingCharacters(in: .whitespacesAndNewlines)
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: param, options: [])
//            // Make the POST request with Alamofire
//            AF.upload(jsonData, to: path, method: .post, headers: APICaller.setHeader())
//                .response { response in
//                    self.convertDataToJSONForContinue(path, param, response.data)
//                    switch response.result {
//                    case .success(let data):
//                        completionHandler(true, [:], nil, data)
//                    case .failure(let error):
//                        completionHandler(false, [:], error as NSError?, nil)
//                    }
//                }
//        } catch {
//            print("Error encoding JSON: \(error)")
//        }
//    }
//    
//    public func apiCallGetWithOutFormData(_ apiName: String, _ param: [String: Any], completionHandler: @escaping responseHandler) {
//        let path : String = APICaller.getFullPath(path: apiName)
//
//        // Perform the Alamofire request
//        AF.request(path, method: .get, parameters: param, headers: APICaller.setHeader())
//            .response { response in
//                self.convertDataToJSON(path, param, response.data)
//                switch response.result {
//                    case .success(let data):
//                        completionHandler(true, [:], nil, data)
//                    case .failure(let error):
//                        completionHandler(false, [:], error as NSError?, nil)
//                }
//            }
//    }
//
//    public func apiCallWithHeader(post: Dictionary<String, Any>, url: String, completionHandler: @escaping responseHandler) {
//        print("Request URL ->   \(url)")
//        print("Request parameter ->   \(post.jsonStringRepresentation?.description ?? "")")
//        NotificationCenter.default.post(name: NSNotification.Name("secureScreen"),
//                                        object: nil)
//
//        AF.upload(multipartFormData: { [self] multipartFormData in
//            for (key, value) in post {
//                if value is NSArray {
//                    let str = json(from: value as AnyObject)
//                    multipartFormData.append((str as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                } else {
//                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                }
//            }
//        }, to: url, method: .post, headers: APICaller.setHeader())
//            .response { response in
//                debugPrint(response)
//                if let responseData = response.response {
//                    if responseData.statusCode == 200 {
//                        switch response.result {
//                        case let .success(data):
//
//                            completionHandler(true, [:], nil, data)
//                        case let .failure(error):
//                            completionHandler(false, [:], error as NSError?, nil)
//                        }
//                    }
//                }
//            }
//       }
//
//    class func convertToDictionary(text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
//
//    func convertDataToJSONForContinue(_ url: String, _ param: [[String: Any]], _ data: Data?) {
//        print("API response\n", APICaller.setHeader(), "\n", url, "\n", param, "\n")
//        do {
//            if let data = data {
//                // Deserialize the data to JSON object
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    // Serialize the JSON object back to a JSON string
//                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
//                    if let jsonString = String(data: jsonData, encoding: .utf8) {
//                        print(jsonString)
//                        let jsonObject = try JSONDecoder().decode(ErrorHandler.self, from: data)
//                        if jsonObject.error ?? "" == "100100"{
//                           
//                            NotificationCenter.default.post(name: NSNotification.Name("PresentLogin"),
//                                                            object: nil)
//                        }
//                    } else {
//                        print("Failed to convert JSON data to string")
//                    }
//                } else {
//                    print("Failed to deserialize JSON data")
//                }
//            } else {
//                print("Data is nil")
//            }
//        } catch {
//            print("Error during JSON serialization:", error.localizedDescription)
//        }
//    }
//    
//    func convertDataToJSON(_ url: String, _ param: [String: Any], _ data: Data?) {
//        print("API response\n:====", APICaller.setHeader(), "\n", url, "\n", param, "\n")
//        do {
//            if let data = data {
//                  
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    // Serialize the JSON object back to a JSON string
//                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
//                    if let jsonString = String(data: jsonData, encoding: .utf8) {
//                        print(jsonString)
//                        let jsonObject = try JSONDecoder().decode(ErrorHandler.self, from: data)
//                        if jsonObject.error ?? "" == "100100"{
//                        
//                            NotificationCenter.default.post(name: NSNotification.Name("PresentLogin"),
//                                                            object: nil)
//                        }
//                    } else {
//                        print("Failed to convert JSON data to string")
//                    }
//                } else {
//                    print("Failed to deserialize JSON data")
//                }
//            } else {
//                print("Data is nil")
//            }
//        } catch {
//            print("Error during JSON serialization:", error.localizedDescription)
//        }
//    }
//
//    
//    func responseData(_ data: Data) {
//        #if DEBUG
//            let json1 = try! JSONSerialization.jsonObject(with: data, options: [])
//            print(json1)
//        #endif
//    }
//}
