//
//  DetailViewController.swift
//  eyeFind
//
//  Created by Portia Sharma on 10/14/16.
//  Copyright © 2016 Portia Sharma. All rights reserved.
//

import UIKit
//import AFNetworking

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var selectedImageUrl = NSURL()
    
    //setup scrollView parameters
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        detailScrollView.delegate = self
        detailScrollView.maximumZoomScale = 5.0
        detailScrollView.minimumZoomScale = 1.0
        self.automaticallyAdjustsScrollViewInsets = false
        detailScrollView.contentInset = UIEdgeInsets.zero
        detailScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        detailScrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    //bring Image from URL
    override func viewDidAppear(_ animated: Bool) {
        fullImageView.bringImageFromUrl(url: selectedImageUrl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //set view for scroll
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.fullImageView
    }

    //share image functionality
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [fullImageView.image! as UIImage], applicationActivities: nil)
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.barButtonItem = (sender)
        }
        present(activityViewController, animated: true, completion: nil)
    }
}
