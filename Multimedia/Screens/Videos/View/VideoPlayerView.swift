//
//  CustomVideoPlayer.swift
//  CustomVideoPlayer
//
//  Created by PHN Tech 2 on 17/06/23.
//https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4

import UIKit
import AVKit


class VideoPlayerView: UIView {
    // MARK: - IBOutlet
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    // @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var go10SecBackButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var go10SecForwordButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    // MARK: - Initialization
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    let avpController = AVPlayerViewController()
    var obj : Any?
    var timer = Timer()
    
    
    // MARK: - Flags
    var islandscape = false
    var isMute = true
    var isPlayVideo = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commitInit()
        initialSetupForUI()
    }
    
    private func commitInit(){
        Bundle.main.loadNibNamed(String(describing: "VideoPlayerView"), owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideShowControls))
        containerView.addGestureRecognizer(tap)
    }
    
    // MARK: - Loading Video in View
    func playVideo(url : String){
        loader.startAnimating()
        let url = URL(string: url)
        player = AVPlayer(url: url!)
        avpController.player = player
        avpController.view.frame.size.height = videoPlayerView.frame.size.height
        avpController.view.frame.size.width = videoPlayerView.frame.size.width
        self.videoPlayerView.addSubview(avpController.view)
        avpController.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avpController.allowsPictureInPicturePlayback = true
        avpController.showsPlaybackControls = false
        player.play()
        addObserver()
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
    }
    
    
    
    // MARK: - Loader Show hide
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    if newStatus == .paused{
                        print("Paused")
                        if self?.isPlayVideo == true{
//                            self?.loader.startAnimating()
//                            self?.loader.isHidden = false
                        }else{
                            self?.loader.stopAnimating()
                            self?.loader.isHidden = true
                        }
                        
                    } else {
                        print("Playing")
                        self?.loader.stopAnimating()
                        self?.loader.isHidden = true
                    }
                }
            }
        }
    }
    
    // MARK: - Initial setup for UI
    func initialSetupForUI(){
        let configuration = UIImage.SymbolConfiguration(pointSize: 12)
        let image = UIImage(systemName: "circle.fill", withConfiguration: configuration)
        slider.setThumbImage(image, for: .normal)
        slider.value = 0
        fullScreenButton.isHidden = true
        backButton.isHidden = true
        go10SecBackButton.isHidden = true
        playPauseButton.isHidden = true
        go10SecForwordButton.isHidden = true
        currentTimeLabel.isHidden = true
        totalDurationLabel.isHidden = true
        slider.isHidden = true
    }
    
    // MARK: - IBActions
//    @IBAction func muteButtonTapped(_ sender: UIButton) {
//        if isMute == true{
//            player.isMuted = true
//            isMute = false
//            muteButton.setBackgroundImage(UIImage(systemName: "speaker.slash"), for: .normal)
//        }else{
//            player.isMuted = false
//            isMute = true
//            muteButton.setBackgroundImage(UIImage(systemName: "speaker.fill"), for: .normal)
//        }
//    }
    
    func navbarHandle(nav : UINavigationController, value : Bool){
        nav.navigationBar.isHidden = value
    }
    
    
    @IBAction func fullScreenButtonTapped(_ sender: UIButton) {
        if islandscape == false{
            setDeviceOrientation(orientation: .landscape)
            fullScreenButton.setBackgroundImage(UIImage(named: "BMPlayer_portialscreen"), for: .normal)
            islandscape = true
        }else{
            fullScreenButton.setBackgroundImage(UIImage(named: "BMPlayer_fullscreen"), for: .normal)
            setDeviceOrientation(orientation: .portrait)
            islandscape = false
        }
    }
    @IBAction func go10SecBackButtonTapped(_ sender: UIButton) {
        // Get the current time of the video
        player.pause()
        let currentTime = CMTimeGetSeconds(player.currentTime())
        // Calculate the target time to seek backward by 10 seconds
        let targetTime = currentTime - 10
        // Make sure the target time is not negative
        let finalTime = max(targetTime, 0)
        // Create a CMTime instance with the final time
        let time = CMTimeMakeWithSeconds(finalTime, preferredTimescale: Int32(NSEC_PER_SEC))
        // Seek the video player to the final time
        player.seek(to: time)
        player.play()
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        if isPlayVideo == true{
            player.pause()
            isPlayVideo = false
            loader.isHidden = true
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }else{
            player.play()
            isPlayVideo = true
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
    }
    
    @IBAction func go10SecForwardButtonTapped(_ sender: UIButton) {
        // Get the current time of the video
        let currentTime = CMTimeGetSeconds(player.currentTime())
        // Calculate the target time to seek forward by 10 seconds
        let targetTime = currentTime + 10
        // Create a CMTime instance with the target time
        let time = CMTimeMakeWithSeconds(targetTime, preferredTimescale: Int32(NSEC_PER_SEC))
        // Seek the video player to the target time
        player.seek(to: time)
    }
    
    @IBAction func sliderProgress(_ sender: UISlider) {
        let progress = sender.value
        let duration = player.currentItem?.duration.seconds ?? 0
        let time = CMTime(seconds: Double(progress) * duration, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.player.seek(to: time)
        player.play()
    }
    
    // MARK: - Function for update slider
    func updatePlaybackProgress(currentTime: CMTime) {
        let duration = player.currentItem?.duration.seconds ?? 0
        let currentTimeSeconds = currentTime.seconds
        self.slider.value = Float(currentTimeSeconds / duration)
        
        let currentMinutes = Int(currentTimeSeconds / 60)
        let currentSeconds = Int(currentTimeSeconds.truncatingRemainder(dividingBy: 60))
        currentTimeLabel.text = String(format: "%02d:%02d", currentMinutes, currentSeconds)
        
        let totalMinutes = Int(duration / 60)
        let totalSeconds = Int(duration.truncatingRemainder(dividingBy: 60))
        totalDurationLabel.text = String(format: "%02d:%02d", totalMinutes, totalSeconds)
        
    }
    // MARK: - function of add time observer to player
    func addObserver(){
        let interval = CMTime(value: 1, timescale: 2)
        obj = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { progressTime in
            if self.slider.isTracking == true{
                self.player.pause()
            }else{
                self.updatePlaybackProgress(currentTime: progressTime)
                if self.isPlayVideo == true{
                    self.player.play()
                }else{
                    self.player.pause()
                }
                
            }
        }
    }
    
    func backButtonTapped(navigationController : UINavigationController){
        navigationController.popViewController(animated: true)
    }
    
    // MARK: - Function of hide show controls
    @objc func hideShowControls(){
        fullScreenButton.isHidden = false
        backButton.isHidden = false
        go10SecBackButton.isHidden = false
        playPauseButton.isHidden = false
        go10SecForwordButton.isHidden = false
        currentTimeLabel.isHidden = false
        totalDurationLabel.isHidden = false
        slider.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5){ [self] in
            fullScreenButton.isHidden = true
            backButton.isHidden = true
            go10SecBackButton.isHidden = true
            playPauseButton.isHidden = true
            go10SecForwordButton.isHidden = true
            currentTimeLabel.isHidden = true
            totalDurationLabel.isHidden = true
            slider.isHidden = true
        }
    }
    
    // MARK: - Handel rotation when device rotate
    func handleRotation() {
        let mobileOrientation = UIApplication.shared.statusBarOrientation
        //let mobileOrientation = UIDevice.current.orientation
        switch mobileOrientation{
        case .portrait, .portraitUpsideDown:
            fullScreenButton.setBackgroundImage(UIImage(named: "BMPlayer_fullscreen"), for: .normal)
            islandscape = false
            
        case .landscapeLeft, .landscapeRight:
            fullScreenButton.setBackgroundImage(UIImage(named: "BMPlayer_portialscreen"), for: .normal)
            islandscape = true
            
        default:
            break
        }
    }
    
    
    
}

extension UIInterfaceOrientationMask {
    var toUIInterfaceOrientation: UIInterfaceOrientation {
        switch self {
        case .portrait:
            return UIInterfaceOrientation.portrait
        case .portraitUpsideDown:
            return UIInterfaceOrientation.portraitUpsideDown
        case .landscapeRight:
            return UIInterfaceOrientation.landscapeRight
        case .landscapeLeft:
            return UIInterfaceOrientation.landscapeLeft
        default:
            return UIInterfaceOrientation.unknown
        }
    }
}


extension VideoPlayerView {
    func setDeviceOrientation(orientation: UIInterfaceOrientationMask) {
        if #available(iOS 16.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
        } else {
            UIDevice.current.setValue(orientation.toUIInterfaceOrientation.rawValue, forKey: "orientation")
        }
    }
}
