//
//  Utilities.swift
//  Tweet_Me
//
//  Created by mai ng on 2/24/21.
//

import UIKit

class Utilities{
    
    func inputContainerView(withImage image: UIImage,textField: UITextField) -> UIView {
        let view = UIView()
        let iv = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        iv.image = image
        view.addSubview(iv)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        iv.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -8).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 24).isActive = true
//        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
//        iv.setDimensions(width: 24, height: 24)
////
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftAnchor.constraint(equalTo: iv.rightAnchor,constant: 8).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
//        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 8).isActive = true
        dividerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dividerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 0.75).isActive = true
//        dividerView.anchor( left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return tf
    }
    
    func attributeButton(_ firstPart: String,_ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributeTitlte  = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributeTitlte.append(NSAttributedString(string:  secondPart, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.setAttributedTitle(attributeTitlte, for: .normal)
        return button
    }
}
