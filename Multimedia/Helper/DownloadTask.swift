//
//  NetworkManager.swift
//  DownloadTask
//
//  Created by PHN Tech 2 on 20/06/23.
///Users/phntech2/Library/Developer/CoreSimulator/Devices/AEB09208-CFEC-4063-9862-25E058541573/data/Containers/Data/Application/32EAD734-DEB9-49F2-9009-625AC506649C/Documents/Bunny.mp4

import Foundation

class DownloadTask: NSObject {
    var resumeData : Data?
    var isDownloadingStarted = false
    var totalDownloaded: Float = 0 {
        didSet {
            self.handleDownloadedProgressPercent?(totalDownloaded)
        }
    }
    typealias progressClosure = ((Float) -> Void)
    var handleDownloadedProgressPercent: progressClosure!
    
    // MARK: - Properties
    //private var configuration: URLSessionConfiguration
    private lazy var session: URLSession = {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        return session
    }()
    
    var task : URLSessionDownloadTask?

    func download(url: String, progress: ((Float) -> Void)?) {
        /// bind progress closure to View
        self.handleDownloadedProgressPercent = progress
    
        guard let url = URL(string: url) else {
            preconditionFailure("URL isn't true format!")
        }
        task = session.downloadTask(with: url)
        task?.resume()
    }
    
    func pauseDownload(){
        task?.cancel { resumeDataOrNil in
            guard let resumeData = resumeDataOrNil else {
              // download can't be resumed; remove from UI if necessary
              return
            }
            self.resumeData = resumeData
        }
    }
    
    func resumeDownload(){
        guard let resumeData = resumeData else {
            // inform the user the download can't be resumed
            return
        }
        task = session.downloadTask(withResumeData: resumeData)
        task?.resume()
    }
}

extension DownloadTask: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        isDownloadingStarted = true
        self.totalDownloaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let videoTitle = UserDefaults.standard.string(forKey: "string") else{return}
        let destinationURL = documentDirectory?.appendingPathComponent("\(videoTitle).mp4")
        do {
        try FileManager.default.moveItem(at: location, to: destinationURL!)
        print("Downloaded File Location: \(destinationURL?.path ?? "")")
        } catch {
        print("Error moving downloaded file: \(error.localizedDescription)")
        }
        isDownloadingStarted = false
        print("downloaded")
        UserDefaults.standard.removeObject(forKey: "string")
    }
}
