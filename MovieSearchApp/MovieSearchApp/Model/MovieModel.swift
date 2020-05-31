//
//  MovieModel.swift
//  MovieSearchApp
//
//  Created by Spoorthy Kancharla on 31/5/20.
//  Copyright © 2020 Spoorthy Kancharla. All rights reserved.
//

import Foundation
import UIKit

/**
 AlbumModel - model which defines the Album values and parse the API reponse
 */
//Retrieving the Feed json result object
struct MovieSearch: Codable{
    var Search: [MovieResult]
}
//Retrieving the Array of Albums json object
struct MovieResult: Codable{
    var Search: [Movie]
}

//Retrieving the Album value from Array of Albums json object
struct Movie: Codable{
    var Title: String
    var Year: String
    var imdbID: String
    var Poster: String
}

//Retrieving the Movie details
struct MovieDetails: Codable{
    var Title: String
    var Year: String
    var imdbID: String
    var Poster: String
    var Runtime: String
    var imdbVotes: String
    var imdbRating: String
    var Director: String
    var Writer:  String
    var Actors: String
    var Plot: String
    
}
