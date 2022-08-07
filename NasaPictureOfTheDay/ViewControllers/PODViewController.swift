//
//  Created by Suman Ghosh on 06/08/22.
//

import UIKit

class PODViewController: UIViewController {
    
    @IBOutlet private weak var podImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var explationTextView: UITextView!
    @IBOutlet weak var favouriteButton: UIButton!
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
        
        configureDatePicker()
    }
    
    private func configureDatePicker() {
        datePicker.maximumDate = Date()
        datePicker.backgroundColor = .white
        datePicker.timeZone = .current
        datePicker.addTarget(self, action: #selector(onDateSelection),
                             for: .valueChanged)
    }
    
    private func loadData(for date: String) {
        viewModel.getAPOD(date: date) { [weak self] state in
            guard let self = self else { return }

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
        
       updateFavouriteButton()
    }
    
    private func updateFavouriteButton() {
        var buttonImage = Constants.starImage
        if pictureOfTheDay?.isFavourite == true {
            buttonImage = Constants.filledStarImage
        }
        
        favouriteButton.setImage(buttonImage, for: .normal)
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
    
    
    @IBAction func markFavourite(_ sender: Any) {
        guard let pictureOfTheDay = pictureOfTheDay else {
            return
        }
        
        let isFavourited = pictureOfTheDay.isFavourite
        
        viewModel.updateFavouritePOD(for: pictureOfTheDay.date,
                                     isFavourited: !isFavourited)
        
        self.pictureOfTheDay?.isFavourite = !isFavourited
        updateFavouriteButton()
    }
    
    @objc func onDateSelection() {
        print("Selected date \(datePicker.date)")
        presentedViewController?.dismiss(animated: false, completion: nil)
        
        let date = datePicker.date.stringFormat()
        loadData(for: date)
    }
}

extension PODViewController {
    
    private enum Constants {
        static let starImage = UIImage(systemName: "star.square")
        static let filledStarImage = UIImage(systemName: "star.square.fill")
    }
}
