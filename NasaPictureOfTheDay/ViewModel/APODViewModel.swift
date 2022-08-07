//
//  Created by Suman Ghosh on 07/08/22.
//

import Foundation

protocol APODViewModel {
    func getAPOD(date: String,
                 completion: @escaping (APODResultState) -> Void)
}


class APODViewModelImpl: APODViewModel {
    
    private let service: APODService
    private(set) var state: APODResultState = .loading
    
    init(service: APODService) {
        self.service = service
    }
    
    func getAPOD(date: String,
                 completion: @escaping (APODResultState) -> Void) {
        state = .loading
        
        service.request(from: .getPOD(date: date)) { result in
            switch result {
            case .success(let responseModel):
                let pictureOfTheDay = APOD(from: responseModel)
                self.state = .success(pod: pictureOfTheDay)
            case .failure(let error):
                self.state = .failed(error: error)
            }
            
            completion(self.state)
        }
    }
}
