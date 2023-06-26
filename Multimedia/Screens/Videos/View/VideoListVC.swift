//
//  ViewController.swift
//  Multimedia
//
//  Created by PHN Tech 2 on 21/06/23.
//

import UIKit
import AVKit

class VideoListVC: UIViewController {
    @IBOutlet weak var videoListTable: UITableView!
    let viewModel = VideoListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        videoListTable.delegate = self
        videoListTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension VideoListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.videoListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = videoListTable.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as? VideoListCell else{return UITableViewCell()}
        cell.videoTitleLabel.text = viewModel.videoListArray[indexPath.row].videoTitle
        cell.thumbnailImageView.setImage(stringUrl: viewModel.videoListArray[indexPath.row].thumbnailUrl)
        
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            250
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoDetailVC = storyboard?.instantiateViewController(withIdentifier: "VideoDetailsVC") as! VideoDetailsVC
        videoDetailVC.vLink = viewModel.videoListArray[indexPath.row].videoLink
        videoDetailVC.vTitle = viewModel.videoListArray[indexPath.row].videoTitle
        videoDetailVC.vDescription = viewModel.videoListArray[indexPath.row].videoDescription
        navigationController?.pushViewController(videoDetailVC, animated: true)
    }
    }

