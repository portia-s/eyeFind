//
//  Model.swift
//  eyeFind
//
//  Created by Portia Sharma on 10/13/16.
//  Copyright © 2016 Portia Sharma. All rights reserved.
//

import Foundation

//Delegate ViewController to update the collectionView when images have finished downloading
protocol PhotoSearchDelegate: class {
    func updateCollectionView()
}


class PhotoSearchModel {
    
    // arrays to store imageUrls, thumbnails & full
    var imageUrls = [String]()
    var fullImageUrls = [String]()
    
    weak var delegate : PhotoSearchDelegate?
    
    //BingImageSearch then JSONSerialized to get url array
    func bingImageSearchAPI(searchString: String, offset: Int) {
        //NSURLSession
        if !searchString.isEmpty {
            //create requestUrl with query parameters: user's search string and offset to take care of which set of 35 pics it downloads
            let urlTemp = "https://api.cognitive.microsoft.com/bing/v5.0/images/search?q=\(searchString)&offset=\(offset)"
            //replace spaces in search string with %
            let url = urlTemp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            var request = URLRequest(url: URL(string: url!)!)
            //header to HTTP GET request containing the APIKey
            request.setValue("216783c59e7e49e8a27d07f114cbacde", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
            
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate:nil,
                delegateQueue:OperationQueue.main
            )
            
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let requestError = error {
                    print(requestError.localizedDescription)
                }
                else {
                    if data != nil {
                        self.extractDataFromResponse(data: data!)
                    }
                }
            })
            task.resume()
        }
    }
    
    //Parsing JSON to extract the urls and delegate ViewController to update collectionView
    func extractDataFromResponse(data: Data) {
        if let itemDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary  {
            if let items = itemDictionary["value"] as? [NSDictionary] {
                for item in items {
                    if let url = item["thumbnailUrl"] as? String {
                        imageUrls.append(url)
                    }
                    if let url2 = item["contentUrl"] as? String {
                        fullImageUrls.append(url2)
                    }
                }
            }
        }
        delegate?.updateCollectionView()
    }

    
}
