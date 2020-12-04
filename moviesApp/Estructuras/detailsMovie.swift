//
//  detailsMovie.swift
//  moviesApp
//
//  Created by Daniel Garcia on 03/12/20.
//

import Foundation

struct genero : Decodable {
    var id: Int = 0
    var name : String
}

struct detailsMovie : Decodable {
    var backdrop_path : String
    var title : String
    var runtime : Int = 0
    var release_date : String
    var vote_average : Double
    var genres : [genero]
    var overview : String
}
