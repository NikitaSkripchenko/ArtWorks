import os.log
import UIKit

@available(iOS 11.0, *)
class ArtWorkTableViewController: UITableViewController {

    var artworks = [ArtWork]()
    var filteredArts = [ArtWork]()
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
             navigationItem.leftBarButtonItem = editButtonItem
       
        if let savedItems = loadArt(){
            artworks += savedItems
        }
        else {
            loadSample()
        }
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredArts.count
        }
        return artworks.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtWorkTableViewCell", for: indexPath) as? ArtWorkTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ArtWorkTableViewCell.")
        }
        let artwork: ArtWork
        if isFiltering() {
            artwork = filteredArts[indexPath.row]
        } else {
            artwork = artworks[indexPath.row]
        }
        cell.nameLabel.text = artwork.name
        cell.yearLabel.text = artwork.year
        cell.descLabel.text = artwork.descriptionT
        cell.genreLabel.text = artwork.genre
        cell.imgLabel.image = artwork.image
        return cell
    }
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if isFiltering(){
                filteredArts.remove(at: indexPath.row)
            }
            artworks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveArt()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         //Get the new view controller using segue.destinationViewController.
         //Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding the new art", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let artWorkDetailViewController = segue.destination as? ArtWorkViewController
                else{
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedArtWorkCell = sender as? ArtWorkTableViewCell
                else{
                    fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedArtWorkCell)
                else{
                    fatalError("The selected cell is not being displayed by the table")
            }
            let selectedArtWork = artworks[indexPath.row]
            artWorkDetailViewController.artWork = selectedArtWork
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
 
    @IBAction func unwindToArtWorkList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ArtWorkViewController,
            let artwork = sourceViewController.artWork {
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                artworks[selectedIndexPath.row] = artwork
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                let newIndexPath = IndexPath(row: artworks.count, section: 0)
                artworks.append(artwork)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveArt()
        }
    }
    //MARK: Private methods
    private func saveArt(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(artworks, toFile: ArtWork.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed", log: OSLog.default, type: .error)
        }
    }
    
    private func loadArt() -> [ArtWork]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArtWork.ArchiveURL.path) as? [ArtWork]
    }
    
    private func loadSample(){
        let photo1 = UIImage(named: "scream")
        guard let art1 = ArtWork(name: "Крик", descriptionT: "Эдвард Мунк", genre: "Импрессионизм", year: "1893", image: photo1) else {
            fatalError("Unable to instantiate art")
        }
        let photo2 = UIImage(named: "blackSquare")
        guard let art2 = ArtWork(name: "Чёрный квадрат", descriptionT: "Каземир Малевич", genre: "Аванд Гард", year: "1915", image: photo2) else {
            fatalError("Unable to instantiate art")
        }
        let photo4 = UIImage(named: "starryNight")
        guard let art4 = ArtWork(name: "Звёздная ночь", descriptionT: "Ван Гог", genre: "Сюрреализм", year: "1889", image: photo4) else {
            fatalError("Unable to instantiate art")
        }
        let photo5 = UIImage(named: "time")
        guard let art5 = ArtWork(name: "Постоянство времени", descriptionT: "Сальвадор Дали", genre: "Сюрреализм", year: "1931", image: photo5) else {
            fatalError("Unable to instantiate art")
        }
        artworks += [art1, art2, art4, art5]
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredArts = artworks.filter({( artwork : ArtWork) -> Bool in
            if artwork.name.lowercased().contains(searchText.lowercased()){
                return artwork.name.lowercased().contains(searchText.lowercased())
            }
            if artwork.descriptionT.lowercased().contains(searchText.lowercased()){
                return artwork.descriptionT.lowercased().contains(searchText.lowercased())
            }
            if artwork.genre.lowercased().contains(searchText.lowercased()){
                return artwork.genre.lowercased().contains(searchText.lowercased())
            }
            if artwork.year.lowercased().contains(searchText.lowercased()){
                return artwork.year.lowercased().contains(searchText.lowercased())
            }
            return false
        })
        
        tableView.reloadData()
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

@available(iOS 11.0, *)
extension ArtWorkTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
