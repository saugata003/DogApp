//
//  DogSubBreedVC.swift
//  DogApp
//
//  Created by Saugata on 11/09/21.
//

import UIKit
import SDWebImage
class DogSubBreedVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subBreedTableView: UITableView!
    let subBreedViewModel = SubBreedViewModel()
    var breedNameString = ""
    var subBreedNameString = ""
    var dogImagesArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProgressHUD()
        subBreedViewModel.delegate = self
        if subBreedNameString.isEmpty {
            titleLabel.text = breedNameString
            subBreedViewModel.getDogsByBreed(breedNameString.lowercased())
        } else {
            titleLabel.text = breedNameString + " " + subBreedNameString
            subBreedViewModel.getDogsBySubBreed(breedNameString.lowercased(), subBreedNameString.lowercased())
        }
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DogSubBreedVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogImagesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogsSubBreedCell", for: indexPath) as! DogsSubBreedCell
        cell.loaderIndicator.startAnimating()
        if let url = URL(string: self.dogImagesArray[indexPath.row])  {
            cell.dogImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "dogPlaceholder"), options: .retryFailed, completed: { _, _, _, _ in
                cell.loaderIndicator.stopAnimating()
            })
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DogImagePreviewVC.instantiate(from: .Main)
        viewController.dogImageUrl = dogImagesArray[indexPath.row]
        present(viewController, animated: true, completion: nil)
    }
}

extension DogSubBreedVC: ViewModelDelegate {
    func viewModelDidUpdate(sender: DogAppViewModel) {
        hideProgressHUD()
        DispatchQueue.main.async {
            if self.subBreedViewModel.reason == .subBreedListByCategory {
                guard let dogImagesArray = self.subBreedViewModel.dogsByBreedModel else { return }
                self.dogImagesArray = dogImagesArray
            } else if self.subBreedViewModel.reason == .subBreedListBySubCategory {
                guard let dogImagesArray = self.subBreedViewModel.dogsBySubBreedModel else { return }
                self.dogImagesArray = dogImagesArray
            }
            self.subBreedTableView.reloadData()
        }
    }
    func viewModelUpdateFailed(error: DogAppError) {
        hideProgressHUD()
        alert(message: error.localizedDescription)
    }
}
