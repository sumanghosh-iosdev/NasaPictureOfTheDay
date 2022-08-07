//
//  Created by Suman Ghosh on 07/08/22.
//

import Foundation

protocol FavouriteViewModel {
    func getFavourites(completion: @escaping ([APOD]) -> Void)
    
    func updateFavouritePOD(for publishedDate: String,
                            isFavourited: Bool)
}

class FavouriteViewModelImpl: FavouriteViewModel {
    private let storage: APODStorage

    init(storage: APODStorage = APODStorageImpl()) {
        self.storage = storage
    }
    
    func getFavourites(completion: @escaping ([APOD]) -> Void) {
        let favourites = storage.getFavourites()
        
        let favPODs: [APOD] = favourites.map{
            return APOD(from: $0)
        }
        
        completion(favPODs)
    }
    
    func updateFavouritePOD(for publishedDate: String, isFavourited: Bool) {
        self.storage.updateFavourite(for: publishedDate,
                                     isFavourite: isFavourited)
    }
}
