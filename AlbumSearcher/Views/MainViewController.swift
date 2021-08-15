//
//  MainViewController.swift
//  AlbumSearcher
//
//  Created by Arina on 06.08.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    var albums: [Album]  = []
    
    let albumDataManager = AlbumDataManager()

    private var sublayer = UIView()
    private let activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.placeholder = "Enter the name of album"
        hideKeyboardWhenTappedOutside()
    }
    
    private func setLoadingView() {
        sublayer = UIView(frame: self.view.bounds)
        sublayer.backgroundColor = UIColor.systemBackground
        sublayer.alpha = 0.7
        view.addSubview(sublayer)
        
        activityIndicator.style = .large
        activityIndicator.center = sublayer.center
        sublayer.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func removeLoadingView() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        sublayer.removeFromSuperview()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath) as! AlbumViewCell
        
        let albumItem = albums[indexPath.row]
        
        cell.setAlbumData(for: albumItem)
        cell.setAlbumCover(for: albumItem.artworkUrl100)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let albumViewController = storyboard.instantiateViewController(withIdentifier: "viewAlbumController") as! AlbumViewController
        let navigationController = UINavigationController(rootViewController: albumViewController)
        
        let albumItem = albums[indexPath.row]
        albumViewController.albumItem = albumItem
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = UIScreen.main.bounds.width/2 - 15
        return CGSize(width: cellWidth, height: cellWidth + 80)
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text
        
        let searchQuery = searchText?.replacingOccurrences(of: " ", with: "+")

        if searchQuery!.count > 0 {
            setLoadingView()
            
            albumDataManager.loadAlbums(query: searchQuery ?? "") { albumArray in
                DispatchQueue.main.async {
                    if let albums = albumArray {
                        self.albums = albums
                    } else {
                        self.albums.removeAll()
                        self.showAlert(title: "Nothing was found", message: "Please try with another album name")
                    }
                    self.removeLoadingView()
                    self.collectionView.reloadData()
                    self.view.endEditing(true)
                }
            }
        } else {
            self.showAlert(title: "Empty search query", message: "Please enter the album name")
        }
    }
    
    private  func hideKeyboardWhenTappedOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
