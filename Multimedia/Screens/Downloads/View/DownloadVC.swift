//
//  DownloadVC.swift
//  Multimedia
//
//  Created by PHN Tech 2 on 26/06/23.
//

import UIKit
import AVKit

class DownloadVC: UIViewController {
    @IBOutlet weak var dowloadVideoTableView: UITableView!
    let viewModel = DownloadViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        dowloadVideoTableView.delegate = self
        dowloadVideoTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.readDownloadedFiles()
        dowloadVideoTableView.reloadData()
    }
}

extension DownloadVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.localVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dowloadVideoTableView.dequeueReusableCell(withIdentifier: "DownloadVideoCell") as! DownloadVideoCell
        cell.videoLabel.text = viewModel.localVideos[indexPath.row]
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let videoURL = documentDirectory!.appendingPathComponent(viewModel.localVideos[indexPath.row])
        let asset = AVAsset(url: videoURL)
        let imageGenrator = AVAssetImageGenerator(asset: asset)
        imageGenrator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 5, preferredTimescale: 1)
        do{
            let thumbCGImage = try imageGenrator.copyCGImage(at: time, actualTime: nil)
            let thumbImage = UIImage(cgImage: thumbCGImage)
            cell.videoImageView.image = thumbImage
        }catch let e{
            print(e.localizedDescription)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let videoURL = documentDirectory!.appendingPathComponent(viewModel.localVideos[indexPath.row])
        print(videoURL)
        let playDownloadVC = storyboard?.instantiateViewController(withIdentifier: "PlayDownloadVC") as! PlayDownloadVC
        playDownloadVC.localVideoUrl = videoURL
        navigationController?.pushViewController(playDownloadVC, animated: true)
    }
}
