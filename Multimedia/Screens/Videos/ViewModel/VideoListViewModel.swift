//
//  VideoListViewModel.swift
//  Multimedia
//
//  Created by PHN Tech 2 on 21/06/23.
//

import Foundation
import AVKit
class VideoListViewModel{
    let videoListArray = [VideoLinks(videoLink:"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                            imageName: "thumb1",
                            videoTitle: "Big Buck Bunny",
                                     videoDescription: "Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain't no bunny anymore! In the typical cartoon tradition he prepares the nasty rodents a comical revenge.", thumbnailUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg"),
                          
        VideoLinks(videoLink: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
                   imageName: "thumb2",
                   videoTitle: "Elephant Dream",
                   videoDescription: "The first Blender Open Movie from 2006", thumbnailUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg"),
        
        VideoLinks(videoLink:"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
                                     imageName: "thumb3",
                                     videoTitle: "For Bigger Blazes",
                   videoDescription: "HBO GO now works with Chromecast -- the easiest way to enjoy online video on your TV. For when you want to settle into your Iron Throne to watch the latest episodes. For $35.\nLearn how to use Chromecast with HBO GO and more at google.com/chromecast.", thumbnailUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg"),
                          
        VideoLinks(videoLink:"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
                                     imageName: "thumb4",
                                     videoTitle: "For Bigger Escape",
                   videoDescription: "Introducing Chromecast. The easiest way to enjoy online video and music on your TV—for when Batman's escapes aren't quite big enough. For $35. Learn how to use Chromecast with Google Play Movies and more at google.com/chromecast.", thumbnailUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerEscapes.jpg"),
                          
        VideoLinks(videoLink: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
                                     imageName: "thumb5",
                                     videoTitle: "For Bigger Fun",
                   videoDescription: "Introducing Chromecast. The easiest way to enjoy online video and music on your TV. For $35.  Find out more at google.com/chromecast.", thumbnailUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerFun.jpg")
    ]
}
