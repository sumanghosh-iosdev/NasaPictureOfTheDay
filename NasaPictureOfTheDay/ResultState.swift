//
//  Created by Suman Ghosh on 07/08/22.
//

import Foundation

enum APODResultState {
    case loading
    case success(pod: APOD)
    case failed(error: Error)
}
