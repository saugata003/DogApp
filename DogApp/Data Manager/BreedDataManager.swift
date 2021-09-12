//
//  DogAppDataManager.swift
//  DogApp
//
//  Created by Saugata on 07/09/21.
//

import Alamofire
enum ListRoute: String {
    case breedListUrl = "api/breeds/list/all"
}

public class ListRouter: APIRouter {
    let route: ListRoute
    override var method: HTTPMethod {
        return .get
    }
    init(_ params: [String: Any]? = nil, route: ListRoute) {
        self.route = route
        super.init(params)
    }
    override var path: String {
        return route.rawValue
    }
}

class BreedDataManager: NSObject {
    public func getBreedListApiCall(success: @escaping (Data) -> Void, failure: @escaping(DogAppError) -> Void) {
        let router = ListRouter(nil, route: .breedListUrl)
        DogAppService.request(router, success: success, failure: failure)
    }
    public func getSubBreesCategoryListApiCall(_ breedName: String, success: @escaping (Data) -> Void, failure: @escaping(DogAppError) -> Void) {
        let router = SubListRouter(nil, route: "api/breed/\(breedName)/list")
        DogAppService.request(router, success: success, failure: failure)
    }
}
