//
//  DogAppViewModel.swift
//  DogApp
//
//  Created by Saugata on 07/09/21.
//

import Foundation
import UIKit
protocol ViewModelDelegate: class {
    func viewModelDidUpdate(sender: DogAppViewModel)
    func viewModelUpdateFailed(error: DogAppError)
}

class DogAppViewModel: NSObject {
    weak var delegate: ViewModelDelegate?
}

struct ServerResponse<Item: Codable>: Codable {
    let status: ServerStatus
    let message: Item?
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}

struct ServerResponses<Item: Codable>: Codable {
    let status: ServerStatus
    let message: [Item]?
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}

enum ServerStatus: String, Codable {
    case success
    case failed
}

struct TestResponse: Codable {
    let status: ServerStatus
    enum CodingKeys: String, CodingKey {
        case status
    }
}

enum AppStoryboard: String {
    case Main
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: .main)
    }
    func viewController<T: UIViewController>(controllerClass: T.Type) -> T {
        let storyboardID = controllerClass.storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }
    static func instantiate(from appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(controllerClass: self)
    }
}
