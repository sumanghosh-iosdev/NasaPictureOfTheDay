//
//  Created by Suman Ghosh on 06/08/22.
//

import UIKit
import WebKit

class PODViewController: UIViewController {
    
    @IBOutlet private weak var podImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var explationTextView: UITextView!
    @IBOutlet private weak var favouriteButton: UIButton!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var mediaView: UIView!
    @IBOutlet private weak var wkWebView: WKWebView!
   
    
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
        datePicker.backgroundColor = .systemBackground
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
        
        configureMediaView(with: pictureOfTheDay)
        
        titleLabel.text = pictureOfTheDay.title
        dateLabel.text = "Published date: \(pictureOfTheDay.date)"
        explationTextView.text = pictureOfTheDay.explanation
        updateFavouriteButton()
    }
    
    private func updateFavouriteButton() {
        var buttonImage = UIImage(systemName: Constants.starImage)
        if pictureOfTheDay?.isFavourite == true {
            buttonImage = UIImage(systemName: Constants.filledStarImage)
        }
        
        favouriteButton.isHidden = false
        favouriteButton.layer.borderColor = UIColor.label.cgColor
        favouriteButton.layer.borderWidth = 1.0
        favouriteButton.setImage(buttonImage, for: .normal)
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

// Media View Setup...
extension PODViewController {
    
    private func configureMediaView(with mediaItem: APOD) {
        if mediaItem.mediaType == .image {
            podImageView.isHidden = false
            wkWebView.isHidden = true
            wkWebView.navigationDelegate = nil

            configureImageView(with: mediaItem)
        } else {
            podImageView.isHidden = true
            wkWebView.isHidden = false

            configureViedeoLayer(with: mediaItem)
        }
    }
    
    private func configureViedeoLayer(with mediaItem: APOD) {
        wkWebView.navigationDelegate = self
        let request = viewModel.webViewLoadRequest(for: mediaItem.url)
        wkWebView.load(request)
    }
    
    private func configureImageView(with mediaItem: APOD) {
        if let data = mediaItem.imageData {
            podImageView.image = UIImage(data: data)
            self.stopActivityIndicator()
        } else {
            viewModel.fetchImageData(for: mediaItem.url,
                                     publisedDate: mediaItem.date) { [weak self] imageData in
                guard let self = self else { return }
                
                if let imageData = imageData {
                    self.pictureOfTheDay?.imageData = imageData
                    podImageView.image = UIImage(data: imageData)
                }
                self.stopActivityIndicator()
            }
        }
    }
}

extension PODViewController {
    
    func startActivityIndicator() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
