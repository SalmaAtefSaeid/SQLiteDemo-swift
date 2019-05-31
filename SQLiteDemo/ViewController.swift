//
//  ViewController.swift
//  SQLiteDemo
//
//  Created by Salma Atef Saeid on 5/30/19.
//  Copyright © 2019 Salma. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var friendTableView: UITableView!
    var friendsList = [Friend]()
    var friendManager = FriendManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        friendTableView.delegate = self
        friendTableView.dataSource = self
        friendsList = friendManager.getAllFriends()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendTableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendTableViewCell
        cell.friendNameLabel.text = friendsList[indexPath.row].name
        cell.friendEmailLabel.text = friendsList[indexPath.row].email
        cell.friendPhoneLabel.text = friendsList[indexPath.row].phone
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            friendManager.deleteFriend(friend: friendsList[indexPath.row])
            friendTableView.reloadData()
        }
    }
}

