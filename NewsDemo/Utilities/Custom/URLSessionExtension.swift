//
//  URLSessionExtension.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-11.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import Foundation

extension URLSession {
    func cancelRunningTaskWithUrl(_ url: URL) {
        URLSession.shared.getAllTasks { tasks in
            tasks
                .filter { $0.state == .running }
                .filter { $0.originalRequest?.url == url }
                .first?
                .cancel()
        }
    }
    
    func cancelAllRunningtasks() {
        URLSession.shared.getAllTasks { tasks in
            tasks
                .filter { $0.state == .running }
                .first?
                .cancel()
        }
    }
}
