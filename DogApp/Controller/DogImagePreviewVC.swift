//
//  DogImagePreviewVC.swift
//  DogApp
//
//  Created by Saugata on 12/09/21.
//

import UIKit
import SDWebImage
class DogImagePreviewVC: UIViewController {
    @IBOutlet weak var dogImagePreview: UIImageView!
    var dogImageUrl = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: dogImageUrl)  {
            dogImagePreview.sd_setImage(with: url, placeholderImage: UIImage(named: "dogPlaceholder"), options: .retryFailed, completed: { _, _, _, _ in
            })
        }
    }
    @IBAction func dismissAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
