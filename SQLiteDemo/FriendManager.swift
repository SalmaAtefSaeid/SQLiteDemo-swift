//
//  FriendManager.swift
//  SQLiteDemo
//
//  Created by Salma Atef Saeid on 5/30/19.
//  Copyright © 2019 Salma. All rights reserved.
//

import Foundation
import SQLite3

class FriendManager{
    
    var db: OpaquePointer?
    var friends = [Friend]()
    
    init(){
        let friend1 = Friend(id: 0, name: "salma", phone: "0123654", email: "salma@gmail.com")
        let friend2 = Friend(id: 0, name: "aya", phone: "098512", email: "aya@gmail.com")
        let friend3 = Friend(id: 0, name: "mai", phone: "05889", email: "mai@gmail.com")
        friends.append(friend1)
        friends.append(friend2)
        friends.append(friend3)
        do{
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("friends_database.sqlite")
            if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                print("error opening database")
            }
        }catch{
            print("error, unable to open database")
        }
        createTable()
        insertAllFriends(friendsList: friends)
    }
    
    func createTable(){
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Friends (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, phone TEXT, email TEXT)", nil, nil, nil) != SQLITE_OK {
            let errormsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errormsg)")
        }
    }
    
    func insertAllFriends(friendsList: [Friend]){

        for friend in friendsList{
            var statement: OpaquePointer?
            let queryString = "INSERT INTO Friends (name, phone, email) VALUES (?,?,?)"

            if sqlite3_prepare(db, queryString, -1, &statement, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return
            }
            
            if sqlite3_bind_text(statement, 1, friend.name, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
                return
            }
            
            if sqlite3_bind_text(statement, 2, friend.phone, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
                return
            }
            
            if sqlite3_bind_text(statement, 3, friend.email, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding name: \(errmsg)")
                return
            }
            
            if sqlite3_step(statement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting hero: \(errmsg)")
                return
            }
            sqlite3_finalize(statement)
        }
        
    }
    func getAllFriends() -> [Friend]{
        
        friends.removeAll()
        let queryString = "SELECT * FROM Friends"
        var statement:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &statement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return friends
        }
        
        while(sqlite3_step(statement) == SQLITE_ROW){
            let id = sqlite3_column_int(statement, 0)
            let name = String(cString: sqlite3_column_text(statement, 1))
            let phone = String(cString: sqlite3_column_text(statement, 2))
            let email = String(cString: sqlite3_column_text(statement, 3))
            friends.append(Friend(id: Int(id), name: name, phone: phone, email: email))
        }
        sqlite3_finalize(statement)
        return friends
    }
    func deleteFriend(friend: Friend){
        
        let deleteStatementStirng = "DELETE FROM Friends WHERE Id = \(friend.id);"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(statement)
        
    }
}
