//
//  ActionSheetLaucher.swift
//  Tweet_Me
//
//  Created by mai ng on 3/8/21.
//

import UIKit


private let reuseIdentifier = "ActionSheetCell"
protocol ActionSheetLaucherDelegate: class {
    func didSelect(option: ActionSheetOptions)
}

//Using the window of the application to add stuff to the window of the application like
class ActionSheetLaucher: NSObject {
    
    //MARK - Properties
    
     
    private let user: User
    private let tableView = UITableView()
    private var window: UIWindow?
    private lazy var viewModel = ActionSheetViewModel(user: user)
    weak var delegate: ActionSheetLaucherDelegate?
    private var tableViewHeight: CGFloat?
    
    //Addign dimming view
    private lazy var blackView:UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismisal))
        view.addGestureRecognizer(tap)
        return view
    }()
    
 
    
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismisal), for: .touchUpInside)
        return button

    }()

    private lazy var footerView: UIView = {
        let view = UIView()

        view.addSubview(cancelButton)

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50/2
        
        return view
        
    }()
//    
    // MARK: - Lifecyle

    
    init(user: User) {
        self.user = user
        super.init()
        configureTableView()
    
    }
    

    
    //MARK: - Helper
    
    func showTableView(_ shouldShow: Bool) {
        guard let window = window else {return}
        guard let height  = tableViewHeight else {return}
        let y = shouldShow ? window.frame.height - height : window.frame.height
        tableView.frame.origin.y = y
    }
    
    func show() {
        print("DEBUG: Show action sheet for user \(user.username)")
        guard let  window = UIApplication.shared.windows.first(where: { $0.isKeyWindow}) else {return}
        self.window = window
        
        // Add blackView to entire screen of our UI Window
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableView)
        let height = CGFloat(viewModel.options.count * 60) + 100
        self.tableViewHeight = height
        tableView.frame = CGRect(x: 0, y: window.frame.height  , width: window.frame.width, height:height )
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.showTableView(true)
        }
        
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
    
    //MARK: - Selector
    @objc func handleDismisal() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 300
        }
        
        
    }
    
    

}

// MARK: UITableViewDataSource

extension ActionSheetLaucher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.options[indexPath.row]
        return cell
    }
}


// MARK: - UITableViewDelegate
extension ActionSheetLaucher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.showTableView(false)
            
        } completion: { [self] (_) in
            delegate?.didSelect(option: option)
        }

        delegate?.didSelect(option: option)
        
    }
    
}
