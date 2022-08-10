//
//  Created by Suman Ghosh on 07/08/22.
//

import Foundation

struct APODResponse: Codable {
    let date: String
    let explanation: String
    let hdurl: String?
    let mediaType: String?
    let serviceVersion: String?
    let title: String
    let url: String
    let copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case date, explanation, hdurl, copyright
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}
