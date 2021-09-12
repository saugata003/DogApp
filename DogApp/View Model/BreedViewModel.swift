//
//  BreedViewModel.swift
//  DogApp
//
//  Created by Saugata on 07/09/21.
//

import Foundation
class BreedViewModel: DogAppViewModel {
    let dataManager = BreedDataManager()
    enum CallReason {
        case breedList
        case subBreedCategoryList
    }
    var reason: CallReason?
    var breedModel: BreedResponseModel? {
        didSet {
            reason = CallReason.breedList
            delegate?.viewModelDidUpdate(sender: self)
        }
    }
    var subBreedCategoryModel: DogsByBreedModel? {
        didSet {
            reason = CallReason.subBreedCategoryList
            delegate?.viewModelDidUpdate(sender: self)
        }
    }
    func getBreedListApiCall() {
        dataManager.getBreedListApiCall(success: { (data) in
            let decoder = JSONDecoder()
            do {
                let item = try decoder.decode(ServerResponse<BreedResponseModel>.self, from: data)
                self.breedModel = item.message
            } catch {
                self.delegate?.viewModelUpdateFailed(error: DogAppServerResponseError.JsonParsing)
            }
        }, failure: { (error) in
            self.delegate?.viewModelUpdateFailed(error: error)
        })
    }
    func getSubBreesCategoryListApiCall(_ breedName: String) {
        dataManager.getSubBreesCategoryListApiCall(breedName, success: { (data) in
            let decoder = JSONDecoder()
            do {
                let item = try decoder.decode(ServerResponse<DogsByBreedModel>.self, from: data)
                self.subBreedCategoryModel = item.message
            } catch {
                self.delegate?.viewModelUpdateFailed(error: DogAppServerResponseError.JsonParsing)
            }
        }, failure: { (error) in
            self.delegate?.viewModelUpdateFailed(error: error)
        })
    }
}
