//
//  HQWebBrowserViewModel.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-12.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import Foundation
import WebKit

protocol HQWebBrowserViewModelProtocol {
    var urlString: String? { get set }
    
    var showLoadingClosure: (()->())? { get set }
    var hideLoadingClosure: (()->())? { get set }
    var updateBookmarkStatusClosure: (()->())? { get set }
    
    func isBookmarked() -> Bool
}

class HQWebBrowserViewModel: HQWebBrowserViewModelProtocol {
    var urlString: String?
    
    var showLoadingClosure: (()->())?
    var hideLoadingClosure: (()->())?
    var updateBookmarkStatusClosure: (()->())?
    
    func isBookmarked() -> Bool {
        if let url = self.urlString {
            if HQBookmarkPersistence.shared.isBookmarked(url: url) {
                return true
            }
        }
        return false
    }
}

extension HQWebBrowserViewModel: HQWebBrowserViewControllerDelegate {
    func getWebViewRequest() -> URLRequest? {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                self.showLoadingClosure?()
                return request
            }
        }
        return nil
    }
    
    func webViewControllerDidFinishLoading() {
        self.showLoadingClosure?()
    }
    
    func webViewControllerDidFailLoading() {
        self.hideLoadingClosure?()
    }
    
    func bookmarkTapped() {
        if let url = self.urlString {
            if HQBookmarkPersistence.shared.isBookmarked(url: url) {
                HQBookmarkPersistence.shared.removeBookmark(url: url)
            } else {
                HQBookmarkPersistence.shared.addBookmark(url: url)
            }
        }
        self.updateBookmarkStatusClosure?()
    }
}
