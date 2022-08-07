//
//  Created by Suman Ghosh on 07/08/22.
//

import Foundation

protocol APODViewModel {
    func getAPOD(date: String,
                 completion: @escaping (APODResultState) -> Void)
    
    func fetchImageData(for url: String,
                        publisedDate: String,
                        completion: (Data?) -> Void)
    
    func updateFavouritePOD(for publishedDate: String,
                            isFavourited: Bool)
}

class APODViewModelImpl: APODViewModel {
    
    private let service: APODService
    private(set) var state: APODResultState = .loading
    private let storage: APODStorage
    
    init(service: APODService = APODServiceImpl(),
         storage: APODStorage = APODStorageImpl()) {
        self.service = service
        self.storage = storage
    }
    
    func getAPOD(date: String,
                 completion: @escaping (APODResultState) -> Void) {
        state = .loading
        if let storedPOD = storage.getAPOD(for: date),
           storedPOD.image != nil {
            let pictureOfTheDay = APOD(from: storedPOD)
            self.state = .success(pod: pictureOfTheDay)
            completion(self.state)
        } else {
            getAPODFromServer(date: date, completion: completion)
        }
    }
    
    private func getAPODFromServer(date: String,
                                   completion: @escaping (APODResultState) -> Void) {
        service.request(from: .getPOD(date: date)) { result in
            switch result {
            case .success(let responseModel):
                let pictureOfTheDay = APOD(from: responseModel)
                self.state = .success(pod: pictureOfTheDay)
                self.storage.store(apod: pictureOfTheDay)
                completion(self.state)
            case .failure(let error):
                self.state = .failed(error: error.localizedDescription)
                completion(self.state)
            }
        }
    }
    
    func fetchImageData(for url: String,
                        publisedDate: String,
                        completion: (Data?) -> Void) {
        do {
            if let imageURL = URL(string: url) {
                let data = try Data(contentsOf: imageURL)
                self.storage.updateImage(with: data,
                                         for: publisedDate)
                completion(data)
            }
        } catch {
            print("Failed to laod image: \(error)")
            completion(nil)
        }
    }
    
    func updateFavouritePOD(for publishedDate: String,
                            isFavourited: Bool) {
        self.storage.updateFavourite(for: publishedDate,
                                     isFavourite: isFavourited)
    }
}
