//
//  SubBreedViewModel.swift
//  DogApp
//
//  Created by Saugata on 11/09/21.
//

import Foundation
class SubBreedViewModel: DogAppViewModel {
    let dataManager = SubBreedDataManager()
    enum CallReason {
        case subBreedListByCategory
        case subBreedListBySubCategory
    }
    var reason: CallReason?
    var dogsByBreedModel: DogsByBreedModel? {
        didSet {
            reason = CallReason.subBreedListByCategory
            delegate?.viewModelDidUpdate(sender: self)
        }
    }
    var dogsBySubBreedModel: DogsByBreedModel? {
        didSet {
            reason = CallReason.subBreedListBySubCategory
            delegate?.viewModelDidUpdate(sender: self)
        }
    }
    func getDogsByBreed(_ breedName: String) {
        dataManager.getDogsByBreed(breedName, success: { (data) in
            let decoder = JSONDecoder()
            do {
                let item = try decoder.decode(ServerResponses<String>.self, from: data)
                self.dogsByBreedModel = item.message
            } catch {
                self.delegate?.viewModelUpdateFailed(error: DogAppServerResponseError.JsonParsing)
            }
        }, failure: { (error) in
            self.delegate?.viewModelUpdateFailed(error: error)
        })
    }
    func getDogsBySubBreed(_ breedName: String, _ subBreedName: String) {
        dataManager.getDogsBySubBreed(breedName, subBreedName, success: { (data) in
            let decoder = JSONDecoder()
            do {
                let item = try decoder.decode(ServerResponses<String>.self, from: data)
                self.dogsBySubBreedModel = item.message
            } catch {
                self.delegate?.viewModelUpdateFailed(error: DogAppServerResponseError.JsonParsing)
            }
        }, failure: { (error) in
            self.delegate?.viewModelUpdateFailed(error: error)
        })
    }
}
