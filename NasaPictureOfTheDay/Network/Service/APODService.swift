//
//  Created by Suman Ghosh on 07/08/22.
//

import Foundation

protocol APODService {
    func request(from endpoint: APODEndpoints,
                 completion: @escaping (Result<APODResponse, APIError>) -> Void)
}

struct APODServiceImpl: APODService {
    
    var urlSession: URLSession
    
    init(urlSession: URLSession = URLSession(configuration: .default)) {
        self.urlSession = urlSession
    }
    
    func request(from endpoint: APODEndpoints,
                 completion: @escaping (Result<APODResponse, APIError>) -> Void) {
        
        urlSession.dataTask(with: endpoint.urlRequest) { data, response, error in
            
            guard let response = response as? HTTPURLResponse,
                  let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            validateResponse(response, data: data, completion: completion)
        }
        .resume()
    }
}

extension APODServiceImpl {
    
    private func validateResponse(_ response: HTTPURLResponse,
                                  data: Data,
                                  completion: @escaping (Result<APODResponse, APIError>) -> Void ) {
        switch response.statusCode {
        case 200...299:
            do {
                let parsedResponse = try self.parseResponse(data: data)
                completion(.success(parsedResponse))
            } catch {
                completion(.failure(.parsingError))
            }
        default:
            completion(.failure(.errorCode(response.statusCode)))
        }
    }
    
    private func parseResponse(data: Data) throws -> APODResponse {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode(APODResponse.self, from: data)
    }
}
