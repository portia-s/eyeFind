//
//  ViewModel.swift
//  eyeFind
//
//  Created by Portia Sharma on 10/16/16.
//  Copyright © 2016 Portia Sharma. All rights reserved.
//

import Foundation
import AFNetworking


// MARK: Extension

extension UIImageView {
    
    //add&manage activity indicator; fetch image for given url
    func bringImageFromUrl(url: NSURL?) {
        
        //setup activity indicator
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame.size.width = 50
        activityIndicatorView.frame.size.height = 50
        activityIndicatorView.center = self.center
        activityIndicatorView.isHidden = false
        activityIndicatorView.color = UIColor.darkGray
        
        addSubview(activityIndicatorView)
        bringSubview(toFront: activityIndicatorView)
        
        //start animating
        activityIndicatorView.startAnimating()
        
        //fetch image, stop animation & remove indicator
        setImageWith(NSURLRequest(url: url as! URL) as URLRequest, placeholderImage: nil, success: { request, response, image in
            
            self.image = image
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
            activityIndicatorView.removeFromSuperview()
            
            }, failure: { request, response, error in
                self.image = UIImage(named: "notfound.png")
                activityIndicatorView.isHidden = true
                activityIndicatorView.stopAnimating()
                activityIndicatorView.removeFromSuperview()
        })
    }
}
