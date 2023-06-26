//
//  UIImageviewExtention.swift
//  Multimedia
//
//  Created by PHN Tech 2 on 26/06/23.
//

import UIKit
import Kingfisher

extension UIImageView{
    func setImage(stringUrl : String){
        guard let url = URL(string: stringUrl) else{return}
        let resource = KF.ImageResource(downloadURL: url, cacheKey: stringUrl)
        kf.indicatorType = .activity
        kf.setImage(with: resource)
    }
}


