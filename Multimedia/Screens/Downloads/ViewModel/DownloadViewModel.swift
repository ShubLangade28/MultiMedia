//
//  DownloadViewModel.swift
//  Multimedia
//
//  Created by PHN Tech 2 on 26/06/23.
//

import Foundation
class DownloadViewModel{
    var localVideos = [String]()
    func readDownloadedFiles(){
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            // Handle error if the document directory is not available
            return
        }
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            let videoFileURLs = fileURLs.filter { url in
                return url.pathExtension == "mp4" || url.pathExtension == "mov" // Add more video file extensions if needed
            }
            let videoFileNames = videoFileURLs.map { url in
                return url.lastPathComponent
            }
            localVideos = videoFileNames
            //print("Video file names: \(videoFileNames)")
        } catch {
            // Handle error if reading the directory fails
            print("Error reading directory: \(error)")
        }
    }
}
