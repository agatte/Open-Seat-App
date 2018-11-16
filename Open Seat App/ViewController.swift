//
//  ViewController.swift
//  Open Seat App
//
//  Created by Anthony Gatte on 11/16/18.
//  Copyright © 2018 Anthony Gatte. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct postStruct {
    let title : String!
    let message : String!
}


class TableViewController: UITableViewController {
    
    var posts = [postStruct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let databaseRef = Database.database().reference()
        
        databaseRef.child("Posts").queryOrderedByKey().observe(.childAdded, with: {
            //expecting variable
            //snapshot in = stuff coming from database reference
            snapshot in
            
            //need to get the value as an NSDictionary first!!!!
            let value = snapshot.value as? NSDictionary
            
            let title = value! ["title"] as! String
            let message = value! ["message"] as! String
            
            self.posts.insert(postStruct(title: title,message: message), at: 0)
            self.tableView.reloadData()
            
        })
        post()
    }
    
    func post(){
        let title = "Title"
        let message = "Message"
        
        let post : [String : AnyObject] = ["title" : title as          AnyObject,
                                           "message" : message as AnyObject]
        
        let databaseRef = Database.database().reference()
        
                                            //(post) = value: AnyObject?
        databaseRef.child("Posts").childByAutoId().setValue(post)
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //var for let?
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        //reference the things inside of the cell
        //label tag is 1
        let label1 = cell?.viewWithTag(1) as! UILabel
        label1.text = posts[indexPath.row].title
        //label tag is 2
        let label2 = cell?.viewWithTag(2) as! UILabel
        label2.text = posts[indexPath.row].message
        
        
        return cell!
    }

}

