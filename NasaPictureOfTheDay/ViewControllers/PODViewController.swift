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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    private let viewModel: APODViewModel = APODViewModelImpl()
    private var pictureOfTheDay: APOD?
    private var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    private func configureView() {
        configureDatePicker()
    }
    
    private func updateData() {
        let date = selectedDate.stringFormat()
        loadData(for: date)
    }
    
    private func configureDatePicker() {
        datePicker.maximumDate = Date()
        datePicker.backgroundColor = .white
        datePicker.timeZone = .current
        datePicker.addTarget(self, action: #selector(onDateSelection),
                             for: .valueChanged)
    }
    
    private func loadData(for date: String) {
        self.startActivityIndicator()
        
        viewModel.getAPOD(date: date) { [weak self] state in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self.startActivityIndicator()
                case .success(let pod):
                    self.pictureOfTheDay = pod
                    self.setupView()
                case .failed(let errorMessage):
                    print(errorMessage)
                    self.showAlert(title: "Failed to load data.",
                                   message: errorMessage)
                    self.stopActivityIndicator()
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
        
        favouriteButton.isHidden = false
        favouriteButton.layer.borderColor = UIColor.black.cgColor
        favouriteButton.layer.borderWidth = 1.0
        favouriteButton.setImage(buttonImage, for: .normal)
    }
    
    private func updateImage() {
        guard let pictureOfTheDay = pictureOfTheDay else {
            return
        }
        
        if let data = pictureOfTheDay.imageData {
            podImageView.image = UIImage(data: data)
            self.stopActivityIndicator()
        } else {
            viewModel.fetchImageData(for: pictureOfTheDay.url,
                                     publisedDate: pictureOfTheDay.date) { [weak self] imageData in
                guard let self = self else { return }
                
                if let imageData = imageData {
                    self.pictureOfTheDay?.imageData = imageData
                    podImageView.image = UIImage(data: imageData)
                }
                self.stopActivityIndicator()
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
        
        selectedDate = datePicker.date
        let date = selectedDate.stringFormat()
        loadData(for: date)
    }
    
    func selectDate(date: String) {
        datePicker.date = Date.dateForm(string: date)
        onDateSelection()
    }
}

extension PODViewController {
    
    private enum Constants {
        static let starImage = UIImage(systemName: "star.square")
        static let filledStarImage = UIImage(systemName: "star.square.fill")
    }
}

extension PODViewController {
    
    private func startActivityIndicator() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    private func stopActivityIndicator() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
