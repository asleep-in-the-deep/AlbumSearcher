//
//  AlbumViewController.swift
//  AlbumSearcher
//
//  Created by Arina on 06.08.2021.
//

import UIKit

class AlbumViewController: UITableViewController {
    
    var albumItem: Album?
    
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var tracksLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setLabels()
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setLabels() {
        albumNameLabel.text = albumItem?.collectionName
        artistNameLabel.text = albumItem?.artistName
        genreLabel.text = albumItem?.primaryGenreName
        releaseDateLabel.text = convertDate(for: albumItem!.releaseDate)
        tracksLabel.text = "\(albumItem?.trackCount ?? 0)"
    }
    
    private func convertDate(for dateString: String) -> String {
        let dateObject = dateString.prefix(10)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: String(dateObject))!
        dateFormatter.dateFormat = "d MMM yyyy"
        
        return dateFormatter.string(from: date)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

}
