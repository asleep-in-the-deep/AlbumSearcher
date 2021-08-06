//
//  AlbumData.swift
//  AlbumSearcher
//
//  Created by Arina on 06.08.2021.
//

import Foundation

struct Result: Decodable {
    let results: [Album]
}

struct Album: Decodable {
    let artistName: String
    let collectionName: String
    let artworkUrl100: String
    let trackCount: Int
    let releaseDate: String
    let primaryGenreName: String
}
