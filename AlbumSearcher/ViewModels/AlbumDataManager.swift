//
//  AlbumDataManager.swift
//  AlbumSearcher
//
//  Created by Arina on 06.08.2021.
//

import Foundation

class AlbumDataManager {
    
    let urlString = "https://itunes.apple.com/search?term="
    let queryString = "&media=music&entity=album&attribute=albumTerm"
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(data, error)
        }
    }
    
    private func request(query: String, completion: @escaping (Data?, Error?) -> Void) {
        let url = URL(string: urlString + query + queryString)
        
        if let url = url {
            let request = URLRequest(url: url)
            
            let task = createDataTask(from: request, completion: completion)
            task.resume()
        }
    }
    
    private func decodeJSON <T: Decodable> (type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()

        guard let data = data, let result = try? decoder.decode(type.self, from: data) else { return nil }

        return result
    }
    
    private func getAlbums(query: String, result: @escaping (Result?) -> Void) {
        request(query: query) { data, error in
            if let error = error {
                print(error.localizedDescription)
                result(nil)
            }
            
            let decoded = self.decodeJSON(type: Result.self, from: data)
            result(decoded)
        }
    }
    
    func loadAlbums(query: String, completion: @escaping ([Album]?)->()) {
        var albums: [Album] = []
        
        DispatchQueue.global(qos: .background).async {
            self.getAlbums(query: query) { result in
                if let result = result {
                    _ = result.results.map { result in
                        albums.append( Album(
                                        artistName: result.artistName,
                                        collectionName: result.collectionName,
                                        artworkUrl100: result.artworkUrl100,
                                        trackCount: result.trackCount,
                                        releaseDate: result.releaseDate,
                                        primaryGenreName: result.primaryGenreName)
                        )
                    }
                    if albums.count > 0 {
                        var sortedAlbums = albums
                        sortedAlbums = sortedAlbums.sorted { $0.collectionName < $1.collectionName }
                        completion(sortedAlbums)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
        }
    }
    
}
