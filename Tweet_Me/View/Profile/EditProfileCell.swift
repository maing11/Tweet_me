//
//  EditProfileCell.swift
//  Tweet_Me
//
//  Created by mai ng on 3/13/21.
//

import UIKit



protocol  EditProfileCellDelegate: class {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell : UITableViewCell {
    // MARK: - Properties
    
    
    weak var delegate: EditProfileCellDelegate?
    
    var viewModel: EditProfileViewModel? {
        didSet {configure() }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var infoTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .left
        tf.textColor = .twitterBlue
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
//        tf.text = "Test User Attribute"

        return tf
    }()

    let bioTextView: InputTextView = {
        let tv = InputTextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = .black
        tv.placeHolderLabel.text = "Bio"
        return tv
    }()
    
    
    
    
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Disable selection style so when the user clicks on thos so it doesn't select anything
        selectionStyle = .none
        
        
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        
        
        contentView.addSubview(infoTextField)
        infoTextField.translatesAutoresizingMaskIntoConstraints = false
        infoTextField.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        infoTextField.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 16).isActive = true
        infoTextField.rightAnchor.constraint(equalTo: rightAnchor, constant:-8 ).isActive = true
        infoTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        contentView.addSubview(bioTextView)
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        bioTextView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        bioTextView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 16).isActive = true
        bioTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        bioTextView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserInfo), name: UITextView.textDidEndEditingNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selector
    
    @objc func handleUpdateUserInfo() {
        delegate?.updateUserInfo(self)
        
        
    }

    
    
    
    // MARK: - Helpers
    
    
    func configure() {
        guard let viewModel = viewModel else {return}
        
        
        infoTextField.isHidden = viewModel.shouldHideTextField
        bioTextView.isHidden = viewModel.shouldHideTextView
        
        titleLabel.text = viewModel.titleText
        
        infoTextField.text = viewModel.optionValue
        
        bioTextView.text = viewModel.optionValue
        bioTextView.placeHolderLabel.isHidden = viewModel.shoudHidePlaceHolderLabel
        
    }
}
