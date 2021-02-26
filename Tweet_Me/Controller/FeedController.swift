//
//  FeedController.swift
//  Tweet_Me
//
//  Created by mai ng on 2/23/21.
//

import UIKit

class FeedController: UIViewController {
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    
    func configureUI() {
        view.backgroundColor = .systemPink
        let imageView  = UIImageView(image: UIImage(named: "tweetme_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
    }
    
}
