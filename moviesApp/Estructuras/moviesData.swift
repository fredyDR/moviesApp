//
//  moviesData.swift
//  moviesApp
//
//  Created by Daniel Garcia on 03/12/20.
//

import Foundation

struct film: Decodable{
    var backdrop_path : String
    var id : Int = 0
    var original_language : String
    var original_title : String
    var poster_path : String
    var release_date : String
    var vote_average : Double
}

struct Root: Decodable {
    
    private enum CodingKeys: String, CodingKey { case page, films = "results", total_pages, total_results}
    
    var page : Int
    var films : [film]
    var total_pages : Int
    var total_results : Int
}
