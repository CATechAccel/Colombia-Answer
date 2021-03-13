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

    private var imageTask: ImageTask?
    var disposeBag = DisposeBag()
    var isFavorited: Bool = false {
        didSet {
            let image: UIImage?
            if isFavorited {
                image = UIImage(named: "red_heart")
            } else {
                image = UIImage(named: "gray_heart")
            }
            favoriteButton.setBackgroundImage(image, for: .normal)
        }
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        imageTask?.cancel()
    }
    
    func configure(work: Work) {
        titleLabel.text = work.title
        isFavorited = work.isFavorited

        guard
            let imageURLString = work.imageURL,
            let imageURL = URL(string: imageURLString)
        else {
            self.iconImageView.image = UIImage(named: "no_image")
            return
        }

        imageTask = loadImage(with: imageURL, into: iconImageView)
    }
}
