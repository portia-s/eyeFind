//
//  DetailViewController.swift
//  eyeFind
//
//  Created by Portia Sharma on 10/14/16.
//  Copyright © 2016 Portia Sharma. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var fullImageView: UIImageView!
    var selectedImageUrl = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailScrollView.delegate = self
        detailScrollView.maximumZoomScale = 5.0
        detailScrollView.minimumZoomScale = 1.0
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidLayoutSubviews() {
        fullImageView.bringImageFromUrl(url: selectedImageUrl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.fullImageView
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
