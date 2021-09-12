//
//  Errors.swift
//  DogApp
//
//  Created by Saugata on 07/09/21.
//
import Foundation

public protocol DogAppErrorCode {
    var code: Int {get}
    var domain: String {get}
    var localizedMessage: String {get}
    var localizedTitle: String? {get}
}

open class DogAppError: NSError {
    public var errorCode: DogAppErrorCode
    open var localizedMessage: String {
        return errorCode.localizedMessage
    }
    open var localizedTitle: String? {
        return errorCode.localizedTitle
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    public init(errorCode: DogAppErrorCode) {
        self.errorCode = errorCode
        super.init(domain: errorCode.domain, code: errorCode.code, userInfo: nil)
    }
}

class DogAppServiceError: DogAppError {
    enum ErrorCode: Int, DogAppErrorCode {
        case unknownError
        case connectionError
        case requestTimeOut
        case noNetwork
        var code: Int {
            return rawValue
        }
        var domain: String {
            return "WebService"
        }
        var localizedMessage: String {
            switch self {
            case .unknownError:
                return "Unknown error. Please try again later."
            case .connectionError:
                return "Could not connect to server. Please try again later."
            case .noNetwork:
                return "Not connected to internet. Please check your connection"
            case .requestTimeOut:
                return "Request Timed out"
            }
        }
        var localizedTitle: String? {
            return "Dog App"
        }
    }
    static func customError(for error: NSError) -> ErrorCode {
        switch error.code {
        case -1009:
            return .noNetwork
        case -1001:
            return .requestTimeOut
        case -1008...(-1002):
            return .connectionError
        default:
            return .unknownError
        }
    }
    public convenience init(error: NSError) {
        let item = DogAppServiceError.customError(for: error)
        self.init(errorCode: item)
    }
}

class DogAppServerResponseError: DogAppError {
    static let JsonParsing = DogAppServerResponseError.init(errorCode: ErrorCode.jsonParsingError)
    static let Unknown = DogAppServerResponseError.init(errorCode: ErrorCode.unknownError)
    enum ErrorCode: DogAppErrorCode {
        case jsonParsingError
        case serverErrorMessage(String)
        case unknownError
        var code: Int {
            return 0
        }
        var domain: String {
            return "ServerResponse"
        }
        var localizedMessage: String {
            switch self {
            case .serverErrorMessage(let message):
                return message
            default:
                return "No Internet Connection Found!!!"
            }
        }
        var localizedTitle: String? {
            return "Dog App"
        }
    }
    public convenience init(error: String) {
        let item = ErrorCode.serverErrorMessage(error)
        self.init(errorCode: item)
    }
}

class DogAppErrorResponse: DogAppError {
    struct ErrorCode: DogAppErrorCode {
        let serverError: String
        var code: Int {
            return 100
        }
        var domain: String {
            return "APIResponse"
        }
        var localizedMessage: String {
            return "No Internet Connection Found!!!"
        }
        var localizedTitle: String? {
            return "Dog App"
        }
    }
    public convenience init(error: String) {
        let item = ErrorCode(serverError: error)
        self.init(errorCode: item)
    }
}
