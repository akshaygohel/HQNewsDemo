//
//  HQWebBrowserViewController.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-12.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import UIKit
import WebKit

protocol HQWebBrowserViewControllerDelegate: AnyObject {
    func getWebViewRequest() -> URLRequest?
    func webViewControllerDidFinishLoading()
    func webViewControllerDidFailLoading()
    
    func bookmarkTapped()
}

class HQWebBrowserViewController: HQViewController {
    
    // MARK: - @IBOutlet  Properties
    @IBOutlet weak var webView: WKWebView!
    private var activitySpinner = UIActivityIndicatorView()
    
    private var bookmarkButton: UIButton?
    
    // MARK: - Properties
    var navigationTitle: String?
    var urlString: String?
    weak var delegate: HQWebBrowserViewControllerDelegate?
    
    lazy var viewModel: HQWebBrowserViewModelProtocol = {
        return HQWebBrowserViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutViewUI()
        loadWebView()
    }
    
    private func layoutViewUI() {
        self.title = navigationTitle
        
        self.activitySpinner.hidesWhenStopped = true
        self.activitySpinner.color = .white
        
        addNavigationButtons()
        
        webView.navigationDelegate = self
        webView.uiDelegate = self

        setupViewModel()
        
        refreshBookbarButtonStatus()
    }
    
    private func addNavigationButtons() {
        self.bookmarkButton = UIButton(type: UIButton.ButtonType.custom)
        
        self.bookmarkButton?.setImage(UIImage(systemName: "bookmark"), for: .normal)
        self.bookmarkButton?.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        self.bookmarkButton?.addTarget(self, action: #selector(self.bookmarkTapped), for: .touchUpInside)
        
        let activityIndicatorButton = UIBarButtonItem(customView: self.activitySpinner)
        if let bookmarkButton = self.bookmarkButton {
            let bookmarkBarButton = UIBarButtonItem(customView: bookmarkButton)
            navigationItem.rightBarButtonItems = [bookmarkBarButton, activityIndicatorButton]
        } else {
            navigationItem.rightBarButtonItems = [activityIndicatorButton]
        }
    }
    
    private func setupViewModel() {
        self.delegate = self.viewModel as? HQWebBrowserViewControllerDelegate
        self.viewModel.urlString = urlString
        
        self.viewModel.showLoadingClosure = { [weak self] in
            self?.showLoading()
        }
        self.viewModel.hideLoadingClosure = { [weak self] in
            self?.hideLoading()
        }
        self.viewModel.updateBookmarkStatusClosure = { [weak self] in
            self?.refreshBookbarButtonStatus()
        }
    }
    
    @objc
    func bookmarkTapped() {
        self.delegate?.bookmarkTapped()
    }
}

extension HQWebBrowserViewController {
    private func showLoading() {
        DispatchQueue.main.async {
            self.activitySpinner.startAnimating()
        }
    }
    
    private func hideLoading() {
        DispatchQueue.main.async {
            self.activitySpinner.stopAnimating()
        }
    }
    
    private func refreshBookbarButtonStatus() {
        DispatchQueue.main.async {
            self.bookmarkButton?.isSelected = self.viewModel.isBookmarked()
        }
    }
}

extension HQWebBrowserViewController {
    func loadWebView() {
        if let request = self.delegate?.getWebViewRequest() {
            self.webView.load(request)
        }
    }
}

// MARK: - WKNavigationDelegate
extension HQWebBrowserViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        self.delegate?.webViewControllerDidFinishLoading()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation, withError error: Error) {
        self.delegate?.webViewControllerDidFailLoading()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

// MARK: - WKUIDelegate
extension HQWebBrowserViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        webView.load(navigationAction.request)
        return nil
    }
}
