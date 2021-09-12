//
//  DogCell.swift
//  DogApp
//
//  Created by Saugata on 09/09/21.
//

import UIKit
class DogBreedCell: UICollectionViewCell {
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var dogNameLabel: UILabel!
    @IBOutlet weak var cellHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
