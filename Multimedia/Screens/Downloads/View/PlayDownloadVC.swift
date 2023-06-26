//
//  PlayDownloadVC.swift
//  Multimedia
//
//  Created by PHN Tech 2 on 26/06/23.
//

import UIKit

class PlayDownloadVC: UIViewController {
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    var localVideoUrl : URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayerView.playVideo(url: localVideoUrl!.absoluteString)
        videoPlayerView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
}
