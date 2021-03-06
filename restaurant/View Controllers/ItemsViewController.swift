
import UIKit

class ItemsViewController: UITableViewController {
    
    private var items = [Any]()
    private let FAVORITES = "Favorites"
    private let NEWS = "News"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
        if (navigationItem.title == FAVORITES) {
            items = UserDefaultsHelper.shared.getFavoriteMenuItems()
            tableView.reloadData()
        }
        else if (navigationItem.title == NEWS) {
            Backendless.sharedInstance().data.of(Article.ofClass()).find({ articles in
                self.items = articles!
                self.tableView.reloadData()
            }, error: { fault in
                AlertViewController.showErrorAlert(fault!, self, nil)
            })
        }
        else {
            if let title = navigationItem.title {
                let queryBuilder = DataQueryBuilder()!
                queryBuilder.setWhereClause(String(format:"category.title='%@'", title))
                Backendless.sharedInstance().data.of(MenuItem.ofClass()).find(queryBuilder, response: { menuItems in
                    self.items = menuItems!
                    self.tableView.reloadData()
                }, error: { fault in
                    AlertViewController.showErrorAlert(fault!, self, nil)
                })
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        if (items.first is MenuItem) {
            let menuItem = items[indexPath.row] as! MenuItem
            cell.titleLabel.text = menuItem.title
            cell.descriptionLabel.text = menuItem.body
            if let picture = menuItem.pictures?.firstObject {
                PictureHelper.shared.setSmallImageFromUrl((picture as! Picture).url!, cell)
            }
        }
        else if (items.first is Article) {
            let article = items[indexPath.row] as! Article
            cell.titleLabel.text = article.title
            cell.descriptionLabel.text = article.body
            PictureHelper.shared.setSmallImageFromUrl((article.picture?.url)!, cell)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (navigationItem.title == FAVORITES) {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let menuItem = items[indexPath.row] as! MenuItem
            UserDefaultsHelper.shared.removeItemFromFavorites(menuItem)
            items = UserDefaultsHelper.shared.getFavoriteMenuItems()
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowItemDetails") {
            let itemDetailsVC = segue.destination as! ItemDetailsViewController
            let indexPath = tableView.indexPath(for: sender as! ItemCell)!
            itemDetailsVC.item = items[indexPath.row]
        }
    }
    
    @IBAction func unwindToItemsVC(segue:UIStoryboardSegue) {
    }    
}
