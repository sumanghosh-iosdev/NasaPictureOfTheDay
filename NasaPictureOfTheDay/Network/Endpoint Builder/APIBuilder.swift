//
//  Created by Suman Ghosh on 07/08/22.
//

import Foundation

protocol APIBuilder {
    var urlRequest: URLRequest { get }
    var baseURL: URL { get }
    var path: String { get }
    var api_key: String { get }
    var params: [URLQueryItem] { get }
}

enum APODEndpoints {
    case getPOD(date: String)
}

extension APODEndpoints: APIBuilder {
    
    var path: String {
        "/planetary/apod"
    }
    
    var api_key: String {
        "XSaPZtgSQjsZgLN3cexKFAh2aqRnSfd8CMvA2Pec"
    }
    
    var baseURL: URL {
        switch self {
        case .getPOD:
            return URL(string: "https://api.nasa.gov")!
        }
    }
    
    var params: [URLQueryItem] {
        var params = [URLQueryItem(name: "api_key", value: api_key)]

        switch self {
        case .getPOD(let date):
            params.append(URLQueryItem(name: "date", value: date))
        }
        
        return params
    }
    
    var urlRequest: URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var urlComponents = URLComponents(string: url.absoluteString)
        urlComponents?.queryItems = params
        
        return URLRequest(url: urlComponents?.url ?? baseURL)
    }
}
