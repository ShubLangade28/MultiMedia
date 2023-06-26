//
//  VideoDetailsVC.swift
//  Multimedia
//
//  Created by PHN Tech 2 on 21/06/23.
//

import UIKit

class VideoDetailsVC: UIViewController {
    let download = DownloadTask()
    @IBOutlet weak var videoPlayerView: VideoPlayerView!
    @IBOutlet weak var videoDescription: UILabel!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var downloadButton: UIButton!
    
    var isDownloading = false
    
    var vLink = ""
    public var vTitle = ""
    var vDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoTitle.text = vTitle
        videoDescription.text = vDescription
        videoPlayerView.playVideo(url: vLink)
        videoPlayerView.navbarHandle(nav: navigationController!, value: false)
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
        setDeviceOrientation(orientation: .portrait)
        navigationController?.popViewController(animated: true)
    }
    
    deinit{
        videoPlayerView.player.replaceCurrentItem(with: nil)
    }
    
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        if download.isDownloadingStarted == false{
            self.downloadButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            isDownloading = true
                        download.download(url: vLink) { [self] progress in
                            progressBar.progress = progress
                            UserDefaults.standard.set(vTitle, forKey: "string")
                            if progress == 1.0{
                                let alert = UIAlertController(title: "Download", message: "Download Completed", preferredStyle: .alert)
                                let okButton = UIAlertAction(title: "OK", style: .cancel) { alert in
                                    self.downloadButton.setBackgroundImage(UIImage(systemName: "arrow.down.circle.fill"), for: .normal)
                                    print("Okey button clicked")
                                }
                                alert.addAction(okButton)
                                self.present(alert, animated: true)
                            }
                        }
        }else{
            if isDownloading == false{
                download.resumeDownload()
                downloadButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
                isDownloading = true
            }else{
                download.pauseDownload()
                downloadButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
                isDownloading = false
            }
        }
        
    
    }
    
}

extension VideoDetailsVC {
    func setDeviceOrientation(orientation: UIInterfaceOrientationMask) {
        if #available(iOS 16.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
        } else {
            UIDevice.current.setValue(orientation.toUIInterfaceOrientation.rawValue, forKey: "orientation")
        }
    }
}
