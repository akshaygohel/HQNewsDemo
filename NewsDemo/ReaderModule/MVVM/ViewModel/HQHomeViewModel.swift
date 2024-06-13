//
//  HQHomeViewModel.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-11.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import Foundation

public enum HQHomeSection: String, CaseIterable {
    case banner
    case newsArticle
}

protocol HQNewArticleViewModelProtocol {
    func articleImageUrl(at index: Int) -> String?
    func articleTitle(at index: Int) -> String?
    func articleContent(at index: Int) -> String?
    func isBookmarked(at index: Int) -> Bool
    func fullArticleUrl(at index: Int) -> String?
    
    func filterBookmarksTapped()
    func filterBookmarksActive() -> Bool
    func actionButtonTapped()
}

protocol HQHomeViewModelProtocol: HQNewArticleViewModelProtocol {
    var reloadTableViewClosure: (()->())? { get set }
    var showAlertClosure: ((String)->())? { get set }
    var updateLoadingIndicatorClosure: (()->())? { get set }
    var updateFilterBookmarkStatusClosure: (()->())? { get set }
    var isFetching: Bool { get }
    
    func fetchHomeData()
    
    func numberOfSections() -> Int
    func numberOfRowsForSection(at index: Int) -> Int
    func section(at index: Int) -> HQHomeSection?
    func headerTitle(at index: Int) -> String?
    func shouldShowRightHeader(at index: Int) -> Bool
    func rightHeaderTitle(at index: Int) -> String?
}

class HQHomeViewModel: HQHomeViewModelProtocol {
    
    private var isFetchedOnce: Bool = false // To restrict fetching again and again on viewDidAppear
    
    private let webService: HQHomeWebServiceProtocol
    
    private var filterBookmarks: Bool = false
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: ((String)->())?
    var updateLoadingIndicatorClosure: (()->())?
    var updateFilterBookmarkStatusClosure: (()->())?
    
    private var sectionArray = [HQHomeSection]()
    
    private var newsArticles: [HQNewsArticle]? {
        get {
            return self.completeNewsArticles?.filter({ article in
                if self.filterBookmarks {
                    if let url = article.url {
                        return HQBookmarkPersistence.shared.isBookmarked(url: url)
                    }
                    return false
                }
                return true
            })
        }
    }
    
    private var completeNewsArticles: [HQNewsArticle]? = nil {
        didSet {
            self.computeSections()
            self.reloadTableViewClosure?()
        }
    }

    var isFetching: Bool = false {
        didSet {
            self.updateLoadingIndicatorClosure?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            if let alertMessage = alertMessage {
                self.showAlertClosure?(alertMessage)
            }
        }
    }
    
    init(webService: HQHomeWebServiceProtocol = HQHomeWebService()) {
        self.webService = webService
    }
    
    func fetchHomeData() {
        if !self.isFetchedOnce {
            self.isFetching = true
            
            self.webService.getNewsArticlesData { [weak self] success, newsArticles, error in
                guard let self = self else { return }
                self.isFetching = false
                if let error = error {
                    if error.rawValue != "cancelled" {
                        self.alertMessage = error.rawValue
                        self.reloadTableViewClosure?()
                    }
                } else {
                    self.isFetchedOnce = true
                    // This will print only in DEBUG Mode. Check file HQLogger.swift
                    // print("\(String(describing: newsArticles))")
                    self.completeNewsArticles = newsArticles?.articles()
                }
            }
        } else {
            // Data already fetched once. Avoid fetching again.
            self.reloadTableViewClosure?()
        }
    }
    
}

extension HQHomeViewModel {

    private func computeSections() {
        // Do some additional filter on the data before presenting on UI.
        self.sectionArray = [HQHomeSection]()
        guard let newsArticles = self.newsArticles else {
            return
        }
        
        // Compute and add banner if needed
        // self.sectionArray.append(.banner)
    
        if (newsArticles.count > 0) {
            self.sectionArray.append(.newsArticle)
        }
    }

    func numberOfSections() -> Int {
        return self.sectionArray.count
    }
    
    func numberOfRowsForSection(at index: Int) -> Int {
        if self.sectionArray.count > index {
            let section = self.sectionArray[index]
            switch section {
            case .banner:
                return 0
            case .newsArticle:
                return self.newsArticles?.count ?? 0
            }
        }
        return 0
    }

    func section(at index: Int) -> HQHomeSection? {
        if self.sectionArray.count > index {
            return self.sectionArray[index]
        }
        return nil
    }
    
    func headerTitle(at index: Int) -> String? {
        if self.sectionArray.count > index {
            let section = self.sectionArray[index]
            switch section {
            case .banner:
                return nil
            case .newsArticle:
                if self.filterBookmarks {
                    return "Your Bookmarked News"
                } else {
                    return "Today's News"
                }
            }
        }
        return nil
    }
    
    func shouldShowRightHeader(at index: Int) -> Bool {
        return false
    }
    
    func rightHeaderTitle(at index: Int) -> String? {
        return nil
    }
}

extension HQHomeViewModel {
    func articleImageUrl(at index: Int) -> String? {
        if let newsArticles = self.newsArticles, newsArticles.count > index {
            return newsArticles[index].urlToImage
        }
        return nil
    }
    
    func articleTitle(at index: Int) -> String? {
        if let newsArticles = self.newsArticles, newsArticles.count > index {
            return newsArticles[index].title
        }
        return nil
    }
    
    func articleContent(at index: Int) -> String? {
        if let newsArticles = self.newsArticles, newsArticles.count > index {
            return newsArticles[index].content
        }
        return nil
    }
    
    func isBookmarked(at index: Int) -> Bool {
        if let newsArticles = self.newsArticles, newsArticles.count > index, let url = newsArticles[index].url {
            return HQBookmarkPersistence.shared.isBookmarked(url: url)
        }
        return false
    }
    
    func fullArticleUrl(at index: Int) -> String? {
        if let newsArticles = self.newsArticles, newsArticles.count > index {
            return newsArticles[index].url
        }
        return nil
    }
}

extension HQHomeViewModel {
    func filterBookmarksTapped() {
        self.filterBookmarks = !self.filterBookmarks
        self.reloadTableViewClosure?()
        self.updateFilterBookmarkStatusClosure?()
    }
    
    func filterBookmarksActive() -> Bool {
        return self.filterBookmarks
    }
    
    func actionButtonTapped() {
        if self.filterBookmarks {
            self.filterBookmarksTapped()
        } else {
            self.fetchHomeData()
        }
    }
}
