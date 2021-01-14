//
//  NetworkLayer.swift
//  Movies
//
//  Created by Administrator on 10.01.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

import Foundation

// MARK: - NetworkLayer

final class NetworkLayer: INetworkLayer {
    
    func getData<T: Decodable>(url: URL, completion: @escaping (T) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result)
            } catch {
                print("JSON error")
            }
            
        }.resume()
    }    
}
