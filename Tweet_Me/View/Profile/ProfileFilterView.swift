//
//  ProfileFilterView.swift
//  Tweet_Me
//
//  Created by mai ng on 3/2/21.
//

import UIKit


private let reuseIdentifier = "ProfileFilterCell"


protocol ProfileFilterViewDelegate: class {
    func filterView(_ view: ProfileFilterView, didSelect index: Int)
    
}
class ProfileFilterView: UIView {
    
    // MARK: - Propperties
    
    weak var delegate: ProfileFilterViewDelegate?
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero,collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
        
    }()
    
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        //Automatically select one and te first one
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left
        )
        
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
        collectionView.backgroundColor = .white

    }
    
    //When you call layoutSubviews then the frame has actually been set up and has been defined
    // Then we can actually access that frame in layout subview
    // This one happen after all the views get laid out  and set
    override func layoutSubviews() {
        addSubview(underLineView)
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        underLineView.bottomAnchor.constraint(equalTo:bottomAnchor).isActive = true
        underLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        //        underLineView.rightAnchor.constraint(equalTo: rightAnchor).isActive =  true
        underLineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        underLineView.widthAnchor.constraint(equalToConstant: frame.width / 3).isActive = true
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - UICollectionViewDataSource

extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOption.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileFilterCell
        
        let option = ProfileFilterOption(rawValue: indexPath.row)
            
        cell.option = option
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    
    {
        let cell = collectionView.cellForItem(at: indexPath)
        let xPosition = cell?.frame.origin.x ?? 0
        
        UIView.animate(withDuration: 0.3){
            self.underLineView.frame.origin.x = xPosition
        }
        
        delegate?.filterView(self, didSelect: indexPath.row)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout


extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(ProfileFilterOption.allCases.count)
        return CGSize(width: frame.width / count  , height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}



