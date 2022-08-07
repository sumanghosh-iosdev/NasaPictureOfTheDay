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
        // Initialization code
    }
    
    func configureCell(with pictureModel: APOD) {
        if let imgData = pictureModel.imageData {
            favImageView.image = UIImage(data: imgData)
        }
        
        titleLabel.text = pictureModel.title
        publishedDate.text = pictureModel.date
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
