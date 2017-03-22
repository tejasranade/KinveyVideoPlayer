//
//  ViewController.swift
//  KinveyVideoPlayer
//
//  Created by Tejas on 3/22/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Kinvey

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var videos:[Kinvey.File] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = Kinvey.sharedClient.activeUser {
            self.fetchAllFiles()
        } else {
            User.login(username: "dev", password: "kinvey") { user, error in
                if let _ = user {
                    self.fetchAllFiles()
                }
            }
        }

    }

    func fetchAllFiles() {
        let store = FileStore.getInstance()
        store.find() {files, error in
            self.videos = files!
            self.tableView.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playVideo(_ sender: AnyObject) {
        // TODO
        
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath)
        cell.textLabel?.text = self.videos[indexPath.row].fileName
        return cell

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = self.videos[indexPath.row]
        
        guard let url = file.downloadURL else {
            return
        }
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)
        player.automaticallyWaitsToMinimizeStalling = true
        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player
        
        // Modally present the player and call the player's play() method when complete.
        present(controller, animated: true) {
            player.play()
        }
    }

}

