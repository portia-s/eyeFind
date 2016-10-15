//
//  ViewController.swift
//  eyeFind
//
//  Created by Portia Sharma on 10/12/16.
//  Copyright © 2016 Portia Sharma. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate, PhotoSearchDelegate {
    
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    var searchController: UISearchController!
    var selectedIndex = Int()
    var vcModel = PhotoSearchModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Image Search"
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        
        let view: UIView = self.searchController.searchBar.subviews[0]
        let subViewsArray = view.subviews
        
        for subView in subViewsArray {
            if subView.isKind(of: UITextField.self) {
                subView.tintColor = UIColor.lightGray
            }
        }
        
        //setting collectionView datasource and delegate
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        vcModel.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text {
            if !searchText.isEmpty {
                vcModel.imageUrls = [String]()
                vcModel.fullImageUrls = [String]()
                vcModel.bingImageSearchAPI(searchString: searchText, offset: vcModel.imageUrls.count)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vcModel.imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as! ImageCollectionViewCell
        myCell.cellImageView.bringImageFromUrl(url: NSURL(string: vcModel.imageUrls[indexPath.row])) //setImageWith(URL(string: (imageURLs[indexPath.row]))!)
        print("IndexPath : ", indexPath.row)
        if vcModel.imageUrls.count - 1 <= indexPath.row {
            vcModel.bingImageSearchAPI(searchString: searchController.searchBar.text!, offset: vcModel.imageUrls.count)
            print("Offset :", vcModel.imageUrls.count)
        }
        return myCell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsPerRow = CGFloat(3)
        let pads = sectionInsets.left * (numberOfCellsPerRow + 1)
        let totalwidth = collectionView.frame.width - pads
        let dimensions = totalwidth / numberOfCellsPerRow
        return CGSize(width: dimensions, height: dimensions)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "toDetailView", sender: self)
        
    }
    
    func updateCollectionView() {
        DispatchQueue.main.async(execute: {
            self.imageCollectionView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let nextVC = segue.destination as! DetailViewController
            nextVC.selectedImageUrl = NSURL(string: vcModel.fullImageUrls[selectedIndex])!
        }
    }
    
}

extension UIImageView {
    
    func bringImageFromUrl(url: NSURL?) {
        
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.frame.size.width = 30
        activityIndicatorView.frame.size.height = 30
        activityIndicatorView.center = self.center
        print("boundsImageView : ", self.center )
        activityIndicatorView.isHidden = false
        activityIndicatorView.color = UIColor.lightGray
        
        addSubview(activityIndicatorView)
        bringSubview(toFront: activityIndicatorView)
        
        activityIndicatorView.startAnimating()
        
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
