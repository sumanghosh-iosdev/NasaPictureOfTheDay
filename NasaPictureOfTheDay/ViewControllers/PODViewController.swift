//
//  Created by Suman Ghosh on 06/08/22.
//

import UIKit

class PODViewController: UIViewController {
    
    @IBOutlet private weak var podImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var explationTextView: UITextView!
    @IBOutlet private weak var datePicker: UIDatePicker!
        
    private let viewModel: APODViewModel = APODViewModelImpl()
    private var pictureOfTheDay: APOD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
    }
    
    private func configureView() {
        let date = Date().stringFormat()
        loadData(for: date)
        datePicker.maximumDate = Date()
        datePicker.backgroundColor = .white
        datePicker.timeZone = .current
        datePicker.addTarget(self, action: #selector(onDateSelection),
                             for: .valueChanged)
    }
    
    private func loadData(for date: String) {
        viewModel.getAPOD(date: date) { state in
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    print("loading")
                    // show activity
                case .success(let pod):
                    self.pictureOfTheDay = pod
                    self.setupView()
                case .failed(let error):
                    print(error)
                    // failure view
                }
            }
        }
    }
    
    private func setupView() {
        guard let pictureOfTheDay = pictureOfTheDay else {
            return
        }
        
        updateImage()
        
        titleLabel.text = pictureOfTheDay.title
        dateLabel.text = "Published date: \(pictureOfTheDay.date)"
        explationTextView.text = pictureOfTheDay.explanation
    }
    
    private func updateImage() {
        guard let pictureOfTheDay = pictureOfTheDay else {
            return
        }
        
        if let data = pictureOfTheDay.imageData {
            podImageView.image = UIImage(data: data)
        } else {
            viewModel.fetchImageData(for: pictureOfTheDay.url,
                                     publisedDate: pictureOfTheDay.date) { imageData in
                if let imageData = imageData {
                    self.pictureOfTheDay?.imageData = imageData
                    podImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    @objc func onDateSelection() {
        print("Selected date \(datePicker.date)")
        presentedViewController?.dismiss(animated: false, completion: nil)
        
        let date = datePicker.date.stringFormat()
        loadData(for: date)
    }
}
