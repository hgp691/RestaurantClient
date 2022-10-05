//
//  RestaurantListCell.swift
//  RestaurantClient
//
//  Created by Horacio Parra Rodriguez on 3/10/22.
//

import UIKit
import SDWebImage

final class RestaurantListCell: UITableViewCell {
    
    static let reuseIdentifier = "RestaurantListCell"
    
    /// IBOutlets
    var mainImageView: UIImageView!
    var titleLabel: UILabel!
    var ratingStack: UIStackView!
    var ratingLabel: UILabel!
    var addressLabel: UILabel!
    var favoriteButton: UIButton!
    
    private(set) var viewModel: RestaurantListCellViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addMainImageView()
        addRating()
        addTitleLabel()
        addAddress()
        addFavoriteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        mainImageView.image = UIImage(named: "placeholder")
        titleLabel.text = ""
        ratingLabel.text = ""
        addressLabel.text = ""
        favoriteButton.setImage(UIImage(), for: .normal)
    }
    
    func setupCell(viewModel: RestaurantListCellViewModel) {
        self.viewModel = viewModel
        setMainImageView()
        setRating()
        setTitle()
        setAddress()
        setFavorite()
    }

}

// MARK: - Extension for UI Configuration
extension RestaurantListCell {
    
    func addMainImageView() {
        
        mainImageView = UIImageView()
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainImageView)
        // Constraints
        mainImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0).isActive = true
        mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0).isActive = true
        mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0).isActive = true
        mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 0.5).isActive = true
        
        mainImageView.layer.cornerRadius = 10.0
        
        mainImageView.contentMode = .scaleAspectFill
        
        mainImageView.clipsToBounds = true
    }
    
    func addTitleLabel() {
    
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        // Constraints
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: mainImageView.bottomAnchor, constant: 10.0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.0).isActive = true
        titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: ratingStack.leadingAnchor, constant: -10.0).isActive = true
        
        titleLabel.font = UIFont(name: "Palatino Bold", size: 20.0)
        titleLabel.numberOfLines = 0
    }
    
    func addRating() {
        
        ratingStack = UIStackView()
        ratingStack.translatesAutoresizingMaskIntoConstraints = false
        ratingStack.axis = .horizontal
        ratingStack.spacing = 5.0
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "tf-logo")
        iconImageView.widthAnchor.constraint(equalToConstant: 19.0).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 23.0).isActive = true
        ratingStack.addArrangedSubview(iconImageView)
        
        ratingLabel = UILabel()
        ratingLabel.textAlignment = .right
        ratingLabel.font = UIFont(name: "Palatino", size: 14.0)
        
        ratingStack.addArrangedSubview(ratingLabel)
        
        
        ratingStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(ratingStack)
        
        // Constraints
        ratingStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        ratingStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
    }
    
    func addAddress() {
        
        addressLabel = UILabel()
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addressLabel)
        
        addressLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        addressLabel.font = UIFont(name: "Palatino", size: 14.0)
        addressLabel.numberOfLines = 0
        addressLabel.textColor = .systemGray
    }
    
    func addFavoriteButton() {
        
        favoriteButton = UIButton()
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(favoriteButton)
        
        favoriteButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -5.0).isActive = true
        favoriteButton.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -5.0).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonDidPressed), for: .touchUpInside)
        
        favoriteButton.backgroundColor = .white
        favoriteButton.layer.cornerRadius = 5.0
        
        self.bringSubviewToFront(favoriteButton)
        
        self.sendSubviewToBack(contentView)
        
    }
    
    @objc func favoriteButtonDidPressed() {
        viewModel?.setFavorite()
        setFavorite()
    }
}

// MARK: - Extension for content Setup
extension RestaurantListCell {
    
    func setMainImageView() {
        guard let urlString = viewModel?.mainImageUrlString,
        let url = URL(string: urlString) else {
            return
        }
        mainImageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
    }
    
    func setTitle() {
        titleLabel.text = viewModel?.titleString
    }
    
    func setRating() {
        ratingLabel.text = viewModel?.ratingString
    }
    
    func setAddress() {
        addressLabel.text = viewModel?.addressString
    }
    
    func setFavorite() {
        guard let imageName = viewModel?.favoriteImageName else {
            return
        }
        favoriteButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
