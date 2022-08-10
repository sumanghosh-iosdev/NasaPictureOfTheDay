//
//  Created by Suman Ghosh on 11/08/22.
//

import Foundation
import WebKit

extension PODViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.stopActivityIndicator()
        print("Unable to load the requested url \(error)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.stopActivityIndicator()
        print("Unable to load the requested url \(error)")
    }
}
