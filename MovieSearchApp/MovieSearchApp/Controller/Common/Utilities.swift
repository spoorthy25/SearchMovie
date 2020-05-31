//
//  Utilities.swift
//  MovieSearchApp
//
//  Created by Spoorthy Kancharla on 31/5/20.
//  Copyright © 2020 Spoorthy Kancharla. All rights reserved.
//

import Foundation

class Utilities {
    
    /**
    downloadImage - download the album thumnail image from the server
    */
    func downloadImage(from url: URL,completionHandler: @escaping (Data?, NSString?) -> Void) {
           getImage(from: url) { data, response, error in
               guard let data = data, error == nil else { return }
               completionHandler( data, nil)
           }
    }
        
    /**
    getImage - download the album thumnail image from the server
    */
    func getImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
