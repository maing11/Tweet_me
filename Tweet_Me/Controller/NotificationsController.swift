//
//  NotificationsController.swift
//  Tweet_Me
//
//  Created by mai ng on 2/23/21.
//

import UIKit


private let reuseIdentifier =  "NotificationCell"

class NotificationsController: UITableViewController {
    // MARK: - Properties
    private var notifications = [Notification]() {
        didSet {tableView.reloadData()}
    }
    
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - Selectors
    
    
    @objc func handleRefresh() {
        fetchNotifications()
    }
    
    // MARK: - API
    
    func fetchNotifications() {
        refreshControl?.beginRefreshing()
        
        //After the fetch is completed we're going to stop refresh
        NotificationService.shared.fetchNotifications { (notifications) in
            self.refreshControl?.endRefreshing()
            self.notifications = notifications
            self.checkIfUserIsFollowed(notification: notifications)
    
        }
    }
    
    
    func checkIfUserIsFollowed(notification: [Notification]) {
        // Determine whether or not our user is followed
        for (index, notification) in notifications.enumerated() {
                if case .follow = notification.type {
                    let user = notification.user
                    
                    UserService.shared.checkIfUserIsFollowed(uid: user.uid) { (isFollowed) in
                        self.notifications[index].user.isFollowed = isFollowed
                    
                }
            }
        }
    }
    
    
    // MARK: - Helper
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
    }
    
}

// MARK: - UITableViewDataSource

extension NotificationsController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self

        return cell
    }
}
// MARK: - UITableViewDelegate

extension NotificationsController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        guard let tweetID = notification.tweetID else {return}

        TweetService.shared.fetchTweet(withTweetID: tweetID) { (tweet) in
            let controller = TweetController(tweet: tweet)

            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

// MARK: - NotificationCellDelegate
extension NotificationsController: NotificationCellDelegate {
    func didTappFollow(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
                
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { (err, ref) in
                cell.notification?.user.isFollowed = false
            }
        } else {
            UserService.shared.unfollowUser(uid: user.uid) { (err, ref) in
                cell.notification?.user.isFollowed = true
            }
        }
    }
    
    func didTappProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}

        let controller = ProfileController(user: user)

        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
