//
//  CaptionTextView.swift
//  Tweet_Me
//
//  Created by mai ng on 2/28/21.
//

import UIKit

// Create custom TextView
class InputTextView:UITextView{
    // MARK: - Properties
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What's happening ?"
        return label 
    }()
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        // Because CaptionTextView is already subclass of UIView
//        backgroundColor = .
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(placeHolderLabel)
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeHolderLabel.topAnchor.constraint(equalTo: topAnchor,constant: 8).isActive = true
        placeHolderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 4).isActive = true
        
        //This is allow us to handle Events when the text start changing
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    
    @objc func handleTextInputChange() {
        placeHolderLabel.isHidden = !text.isEmpty
//        if text.isEmpty {
//            placeHolderLabel.isHidden = false
//        } else {
//             placeHolderLabel.isHidden = true
//        }
    }
    
    
}
