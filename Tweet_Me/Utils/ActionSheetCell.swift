//
//  ActionSheetCell.swift
//  Tweet_Me
//
//  Created by mai ng on 3/8/21.
//

import UIKit



class ActionSheetCell: UITableViewCell {
    //MARK: - Properties
    
    var option: ActionSheetOptions? {
        didSet{configure()}
    }
    
    private let optionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "tweetme_logo_blue")
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test Option"
        return  label
    }()
    
    // MARK: Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(optionImageView)
        optionImageView.centerY(inView: self)
        optionImageView.translatesAutoresizingMaskIntoConstraints = false
        optionImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        optionImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        optionImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.leftAnchor.constraint(equalTo: optionImageView.rightAnchor, constant: 12).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    
    func configure() {
        titleLabel.text = option?.description
         
    }
    
    
    
}
