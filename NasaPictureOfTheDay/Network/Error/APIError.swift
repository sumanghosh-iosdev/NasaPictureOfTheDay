//
//  Created by Suman Ghosh on 07/08/22.
//

import Foundation

enum APIError: Error {
    case parsingError
    case errorCode(Int)
    case noNetwork
    case unknown
}

extension APIError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .parsingError:
            return "Unable to parse the json response."
        case .errorCode(let code):
            return "Request failed error code: \(code)"
        case .unknown:
            return "Unknown error."
        case .noNetwork:
            return "The Internet connection appears to be offline."
        }
    }
}
