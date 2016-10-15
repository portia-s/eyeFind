//
//  Model.swift
//  eyeFind
//
//  Created by Portia Sharma on 10/13/16.
//  Copyright © 2016 Portia Sharma. All rights reserved.
//

import Foundation

protocol PhotoSearchDelegate: class {
    func updateCollectionView()
}


class PhotoSearchModel {
    
    var imageUrls = [String]()
    var fullImageUrls = [String]()
    
    weak var delegate : PhotoSearchDelegate?
    
    //NSURLSession
    func bingImageSearchAPI(searchString: String, offset: Int) {
        if !searchString.isEmpty {
            let urlTemp = "https://api.cognitive.microsoft.com/bing/v5.0/images/search?q=\(searchString)&offset=\(offset)"
            let url = urlTemp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            var request = URLRequest(url: URL(string: url!)!)
            request.setValue("216783c59e7e49e8a27d07f114cbacde", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
            
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate:nil,
                delegateQueue:OperationQueue.main
            )
            
            let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
                if let requestError = errorOrNil {
                    print(requestError.localizedDescription)
                }
                else {
                    if dataOrNil != nil {
                        self.extractDataFromResponse(data: dataOrNil!)
                    }
                }
            })
            task.resume()
        }
    }
    
    //Parsing JSON
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
