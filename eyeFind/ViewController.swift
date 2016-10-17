//
//  ViewController.swift
//  eyeFind
//
//  Created by Portia Sharma on 10/12/16.
//  Copyright © 2016 Portia Sharma. All rights reserved.
//

import UIKit
//import AFNetworking

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate, PhotoSearchDelegate {
    
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    var searchController: UISearchController!
    
    //sets border around collectionView
    let sectionInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    //passed onto DetailVC for full image
    var selectedIndex = Int()
    
    //instance to access model for URLSessin & JSON Parsing
    var vcModel = PhotoSearchModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // searchController to use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        //
        searchController.dimsBackgroundDuringPresentation = false
        //
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Image Search"
        //create searchBar in NavBar
        self.navigationItem.titleView = searchController.searchBar
        //
        searchController.hidesNavigationBarDuringPresentation = false
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        
        //Recustomize* cursor in searchBar textField from white to gray
        let view: UIView = self.searchController.searchBar.subviews[0]
        let subViewsArray = view.subviews
        
        for subView in subViewsArray {
            if subView.isKind(of: UITextField.self) {
                subView.tintColor = UIColor.lightGray
            }
        }
        
        //setting self collectionView's datasource and delegate
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        //setting self to be model's delegate
        vcModel.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: UICollectionViewDatasource & UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vcModel.imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath) as! ImageCollectionViewCell
        myCell.cellImageView.bringImageFromUrl(url: NSURL(string: vcModel.imageUrls[indexPath.row]))
        //print("IndexPath : ", indexPath.row)
        //reFetch next set of urls as collectionView usesup* current set of images
        if vcModel.imageUrls.count - 1 <= indexPath.row {
            vcModel.bingImageSearchAPI(searchString: searchController.searchBar.text!, offset: vcModel.imageUrls.count)
            //print("Offset :", vcModel.imageUrls.count)
        }
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "toDetailView", sender: self)
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
    
    
    // MARK: Helper methods
    
    //initialize url arrays & initiate photo search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchController.searchBar.text {
            if !searchText.isEmpty {
                vcModel.imageUrls = [String]()
                vcModel.fullImageUrls = [String]()
                vcModel.bingImageSearchAPI(searchString: searchText, offset: vcModel.imageUrls.count)
            }
        }
    }

    func updateCollectionView() {
        DispatchQueue.main.async(execute: {
            self.imageCollectionView.reloadData()
        })
    }
    
    //pass selected full image url to detailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let nextVC = segue.destination as! DetailViewController
            nextVC.selectedImageUrl = NSURL(string: vcModel.fullImageUrls[selectedIndex])!
        }
    }
    
}

