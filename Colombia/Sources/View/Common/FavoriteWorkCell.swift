//
//  FavoriteWorkCell.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

import UIKit
import RxSwift
import Nuke

final class FavoriteWorkCell: UICollectionViewCell {
    @IBOutlet private(set) weak var favoriteButton: UIButton!

    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 1
            titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        }
    }

    @IBOutlet private weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.layer.cornerRadius = 8
            iconImageView.contentMode = .scaleAspectFill
        }
    }

    private var imageTask: ImageTask?
    var disposeBag = DisposeBag()
    var isFavorited: Bool = false {
        didSet {
            favoriteButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
            favoriteButton.tintColor = isFavorited ? .systemPink: .gray
        }
    }

    override func prepareForReuse() {
        disposeBag = DisposeBag()
        imageTask?.cancel()
    }

    func configure(work: Work) {
        titleLabel.text = work.title
        isFavorited = work.isFavorited
        if let imageURLString = work.imageURL, let imageURL = URL(string: imageURLString) {
            imageTask = loadImage(with: imageURL, into: iconImageView)
        } else {
            iconImageView.image = #imageLiteral(resourceName: "no_image")
        }
    }
}
