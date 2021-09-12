//
//  SubBreedDataManager.swift
//  DogApp
//
//  Created by Saugata on 11/09/21.
//

import Alamofire

public class SubListRouter: APIRouter {
    let route: String
    override var method: HTTPMethod {
        return .get
    }
    init(_ params: [String: Any]? = nil, route: String) {
        self.route = route
        super.init(params)
    }
    override var path: String {
        return route
    }
}

class SubBreedDataManager: NSObject {
    public func getDogsByBreed(_ breedName: String, success: @escaping (Data) -> Void, failure: @escaping(DogAppError) -> Void) {
        let router = SubListRouter(nil, route: "api/breed/\(breedName)/images")
        DogAppService.request(router, success: success, failure: failure)
    }
    public func getDogsBySubBreed(_ breedName: String, _ subBreedName: String, success: @escaping (Data) -> Void, failure: @escaping(DogAppError) -> Void) {
        let router = SubListRouter(nil, route: "api/breed/\(breedName)/\(subBreedName)/images")
        DogAppService.request(router, success: success, failure: failure)
    }
}
