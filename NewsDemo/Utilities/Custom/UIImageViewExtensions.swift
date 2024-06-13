//
//  UIImageViewExtensions.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-12.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import UIKit

class HQImageView: UIImageView {
    private var task: URLSessionDataTask?
    
    func loadImage(from url: URL, contentMode mode: ContentMode = .scaleAspectFit, completion: ((UIImage?) -> Void)? = nil) {
        contentMode = mode
        self.task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                completion?(nil)
                return
            }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                completion?(image)
            }
        }
        self.task?.resume()
    }
    
    func loadImage(from link: String?, contentMode mode: ContentMode = .scaleAspectFit, completion: ((UIImage?) -> Void)? = nil) {
        self.task?.cancel()
        self.image = nil

        guard let link = link, let url = URL(string: link) else {
            completion?(nil)
            return
        }
        loadImage(from: url, contentMode: mode, completion: completion)
    }

}
