import os.log
import UIKit

class ArtWorkTableViewController: UITableViewController {

    var artworks = [ArtWork]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        loadSample()

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
    
    //1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //2
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artworks.count
    }
    //3
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cellIdentifier = "ArtWorkTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtWorkTableViewCell", for: indexPath) as? ArtWorkTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ArtWorkTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let art = artworks[indexPath.row]
        
        cell.nameLabel.text = art.name
        cell.yearLabel.text = art.year
        cell.descLabel.text = art.description
        cell.genreLabel.text = art.genre
        cell.imgLabel.image = art.image
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
            artworks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
           fatalError("Unexpected Segue Identifier; \(segue.identifier)")
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
        }
    }
    
    private func loadSample(){
        let photo1 = UIImage(named: "scream")
        guard let art1 = ArtWork(name: "Крик", description: "Эдвард Мунк", genre: "Импрессионизм", year: "1893", image: photo1) else {
            fatalError("Unable to instantiate art")
        }
        let photo2 = UIImage(named: "blackSquare")
        guard let art2 = ArtWork(name: "Чёрный квадрат", description: "Каземир Малевич", genre: "Аванд Гард", year: "1915", image: photo2) else {
            fatalError("Unable to instantiate art")
        }
        let photo4 = UIImage(named: "starryNight")
        guard let art4 = ArtWork(name: "Звёздная ночь", description: "Ван Гог", genre: "Сюрреализм", year: "1889", image: photo4) else {
            fatalError("Unable to instantiate art")
        }
        let photo5 = UIImage(named: "time")
        guard let art5 = ArtWork(name: "Постоянство времени", description: "Сальвадор Дали", genre: "Сюрреализм", year: "1931", image: photo5) else {
            fatalError("Unable to instantiate art")
        }
        artworks += [art1, art2, art4, art5]
    }
}
