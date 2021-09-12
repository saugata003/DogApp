//
//  DogSubBreedCategoryVC.swift
//  DogApp
//
//  Created by Saugata on 12/09/21.
//

import UIKit
import SDWebImage
import SwiftyJSON
class DogSubBreedCategoryVC: UIViewController {
    @IBOutlet weak var dogCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarheightConstrant: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    var breedNameString = ""
    var filteredBreedArray: [String] = []
    var dogImagesArray: [String] = []
    var workItem: DispatchWorkItem?
    var subBreedArray: [String] = []
    let subBreedViewModel = SubBreedViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = breedNameString
        filteredBreedArray = subBreedArray
        setupSearchBar()
        getDogImages()
    }
    func getDogImages() {
        workItem = DispatchWorkItem {
            for i in 0..<self.filteredBreedArray.count {
                DogAppService.apiGet(serviceName: APIConstants.baseURL + "api/breed/\(self.breedNameString.lowercased())/\(self.subBreedArray[i].lowercased())/images/random", parameters: ["counter":i]) { (response, error, count) in
                    if let item = self.workItem, !item.isCancelled {
                        sleep(1)
                    }
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    if i < self.dogImagesArray.count && !self.dogImagesArray.isEmpty {
                        if let response = response {
                            self.dogImagesArray[i] = JSON(response.dictionaryObject!)["message"].string!
                        } else {
                            self.dogImagesArray[i] = ""
                        }
                        self.dogCollectionView.reloadItems(at: [IndexPath(item: i, section: 0)])
                    }
                }
            }
        }
        workItem?.notify(queue: .main) {
//            print("done")
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
            self.workItem?.cancel()
        }
        DispatchQueue.main.async(execute: workItem!)
    }
    private func setupSearchBar() {
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        searchBar.tintColor = UIColor(red: 222.0/255.0, green: 40.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        searchBar.placeholder = "Search"
        searchBar.roundCorners(4.0, 1, .clear)
        searchBar.backgroundImage = UIImage()
        searchBar.setImage(UIImage(named: "searchBarCrossIcon")?.withRenderingMode(.alwaysTemplate), for: .clear, state: .normal)
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func searchButtonAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {
            self.searchBarheightConstrant.constant = (self.searchBarheightConstrant.constant == 0) ? 68 : 0
            self.searchBar.text = ""
            self.view.layoutIfNeeded()
        }
    }
}

extension DogSubBreedCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredBreedArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogBreedCell", for: indexPath as IndexPath) as! DogBreedCell
        cell.dogNameLabel.text = filteredBreedArray[indexPath.row].capitalized
        cell.cellHeightConstraint.constant = (collectionView.bounds.size.width - 10) / 2
        cell.cellWidthConstraint.constant = (collectionView.bounds.size.width - 10) / 2
        cell.loaderIndicator.startAnimating()
        if let url = URL(string: self.dogImagesArray[indexPath.row]), !self.dogImagesArray[indexPath.row].isEmpty, self.dogImagesArray[indexPath.row] != "false" {
            cell.dogImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "dogPlaceholder"), options: .retryFailed, completed: { _, _, _, _ in
                cell.loaderIndicator.stopAnimating()
            })
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = DogSubBreedVC.instantiate(from: .Main)
        viewController.breedNameString = breedNameString
        viewController.subBreedNameString = filteredBreedArray[indexPath.row].capitalized
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension DogSubBreedCategoryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.size.width - 10) / 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

extension DogSubBreedCategoryVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            if searchText.count >= 3 {
                self.workItem?.cancel()
                self.dogImagesArray.removeAll()
                self.filteredBreedArray = self.subBreedArray.filter { item in
                    return item.lowercased().contains(searchText.lowercased())
                }
                self.dogImagesArray = self.filteredBreedArray.map({ "\($0.isEmpty)" })
                self.getDogImages()
                self.dogCollectionView.reloadData()
            } else if searchText.count == 0 {
                self.workItem?.cancel()
                self.filteredBreedArray = self.subBreedArray
                self.dogImagesArray = self.filteredBreedArray.map({ "\($0.isEmpty)" })
                self.getDogImages()
                self.dogCollectionView.reloadData()
            }
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        DispatchQueue.main.async {
            self.workItem?.cancel()
            self.filteredBreedArray = self.subBreedArray
            self.dogImagesArray = self.filteredBreedArray.map({ "\($0.isEmpty)" })
            self.getDogImages()
            self.dogCollectionView.reloadData()
        }
    }
}
