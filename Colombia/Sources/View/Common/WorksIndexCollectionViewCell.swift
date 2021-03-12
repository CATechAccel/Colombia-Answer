//
//  WorksIndexCollectionViewCell.swift
//  Colombia
//
//  Created by 化田晃平 on R 3/02/14.
//

import UIKit
import RxSwift
import Nuke

final class WorksIndexCollectionViewCell: UICollectionViewCell { // TODO: 名前とか諸々変える
    @IBOutlet private(set) weak var favoriteButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 1
            titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        }
    }
    @IBOutlet private weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.contentMode = .scaleAspectFill
        }
    }
    
    var disposeBag = DisposeBag()
    var isFavorited: Bool = false {
        didSet {
            if isFavorited {
                let image = UIImage(named: "red_heart")
                favoriteButton.setBackgroundImage(image, for: .normal)
            }
            else {
                let image = UIImage(named: "gray_heart")
                favoriteButton.setBackgroundImage(image, for: .normal)
            }
        }
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func configure(work: Work) {
        titleLabel.text = work.title
        
        if let imageUrlString = work.imageURL, let imageUrl = URL(string: imageUrlString) {
            loadImage(with: imageUrl, into: self.iconImageView)
        } else {
            let image = UIImage(named: "no_image")
            self.iconImageView.image = image
        }
    }
}
