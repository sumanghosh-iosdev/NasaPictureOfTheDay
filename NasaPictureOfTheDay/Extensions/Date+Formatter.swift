//
//  Created by Suman Ghosh on 07/08/22.
//

import Foundation

extension Date {
    
    func stringFormat(with format: String = "YYYY-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: self)
    }
    
    static func dateForm(string: String,
                         with format: String = "YYYY-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current
        return dateFormatter.date(from: string) ?? Date()
    }
}
