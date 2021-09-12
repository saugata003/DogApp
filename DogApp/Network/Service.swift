//
//  SerVices.swift
//  DogApp
//
//  Created by Saugata on 07/09/21.
//

import Alamofire
import SwiftyJSON
struct APIConstants {
    static let baseURL = "https://dog.ceo/"
    static let contentType = "application/json; charset=utf-8"
}

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

public class APIRouter: APIConfiguration {
    var method: HTTPMethod {
        return .post
    }
    var path: String {
        return ""
    }
    var parameters: Parameters?
    init(_ params: Parameters? = nil ) {
        parameters = params
    }
    public func asURLRequest() throws -> URLRequest {
        let url = try APIConstants.baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.setValue(APIConstants.contentType, forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        if method.rawValue == HTTPMethod.get.rawValue {
            return try URLEncoding.queryString.encode(request, with: parameters)
        } else {
            return try JSONEncoding.default.encode(request, with: parameters)
        }
    }
}

class DogAppService: NSObject {
    static func request(_ request: URLRequestConvertible, success:@escaping (Data) -> Void, failure:@escaping (DogAppError) -> Void) {
        AF.request(request).responseData { (responseObject) -> Void in
            if let data = responseObject.data {
                let decoder = JSONDecoder()
                if let item = try? decoder.decode(TestResponse.self, from: data), item.status == .failed {
                    let error = DogAppErrorResponse.init(error: item.status.rawValue)
                    failure(error)
                } else {
                    success(data)
                }
            } else {
                var item: DogAppError
                if let error = responseObject.error as NSError? {
                    item = DogAppServiceError.init(error: error)
                } else {
                    item = DogAppServiceError.init(errorCode: DogAppServiceError.ErrorCode.unknownError)
                }
                failure(item)
            }
        }
    }
    static func apiGet(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (JSON?, NSError?, Int) -> ()) {
        AF.request(serviceName, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse) in

            switch(response.result) {
            case .success(_):
                if let data = response.data {
                    let json = JSON(data)
                    completionHandler(json,nil, parameters!["counter"] as! Int)
                }
                break
            case .failure(_):
                if let error = response.error as NSError? {
                    completionHandler(nil,error, parameters!["counter"] as! Int)
                }
                break
            }
        }
    }
}
