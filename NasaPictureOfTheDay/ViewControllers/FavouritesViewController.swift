//
//  Created by Suman Ghosh on 07/08/22.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: FavouriteViewModel = FavouriteViewModelImpl()
    
    private var favourites = [APOD]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getFavourites { [weak self] favPODs in
            guard let self = self else { return }
            self.favourites = favPODs
            self.tableView.reloadData()
        }
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: String(describing: FavouritePODCell.self),
                                 bundle: nil),
                           forCellReuseIdentifier: String(describing: FavouritePODCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension FavouritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FavouritePODCell.self),
                                                    for: indexPath) as? FavouritePODCell {
            
            cell.configureCell(with: favourites[indexPath.row])
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
       return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let deletedItem = favourites[indexPath.row]

        tableView.beginUpdates()
        favourites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        
        viewModel.updateFavouritePOD(for: deletedItem.date, isFavourited: false)
    }
}

extension FavouritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = favourites[indexPath.row]
        
        if let tabController = self.tabBarController,
           let podVC = self.tabBarController?.viewControllers?.first as? PODViewController {
            podVC.selectDate(date: selectedItem.date)
            tabController.selectedIndex = 0
        }
    }
}
