//
//  Created by Suman Ghosh on 07/08/22.
//

import UIKit

class FavouritePODCell: UITableViewCell {

    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with pictureModel: APOD) {
        if let imgData = pictureModel.imageData {
            favImageView.image = UIImage(data: imgData)
        } else {
            favImageView.image = UIImage(named: Constants.videoPlaceHolderImage)
        }
        
        titleLabel.text = pictureModel.title
        
        let publisedDate = Date.dateForm(string: pictureModel.date)
        
        publishedDate.text = publisedDate.stringFormat(with: "dd-MMM-YYYY")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
