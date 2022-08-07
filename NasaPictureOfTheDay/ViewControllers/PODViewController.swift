//
//  Created by Suman Ghosh on 06/08/22.
//

import UIKit

class PODViewController: UIViewController {

    @IBOutlet weak var podImageView: UIImageView!
    
    let viewModel: APODViewModel = APODViewModelImpl(service: APODServiceImpl())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.string(from: Date())
        
        viewModel.getAPOD(date: date) { state in
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    print("loading")
                    // show activity
                case .success(let pod):
                    self.loadImage(pod: pod)
                case .failed(let error):
                    print(error)
                    // failure view
                }
            }
        }
    }
    
    private func loadImage(pod: APOD) {
        do {
            if let imageURL = URL(string: pod.url) {
                let data = try Data(contentsOf: imageURL)
                podImageView.image = UIImage(data: data)
            }
        } catch {
            print(error)
        }
    }

}
