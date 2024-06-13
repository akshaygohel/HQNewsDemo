//
//  HQHomeViewController.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-11.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import UIKit

/// Delegate protocol for `SixDigitCodeViewController` Navigation from Coordinator
protocol HQHomeViewControllerNavigationDelegate: HQCoordinator {
    func homeNavigateTo(link: String, withTitle title: String?)
}

class HQHomeViewController: HQViewController {

    var navigationDelegate: HQHomeViewControllerNavigationDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var infoContainer: UIStackView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    private var bookmarkButton: UIButton?
    private var activitySpinner = UIActivityIndicatorView()
    
    lazy var viewModel: HQHomeViewModelProtocol = {
        return HQHomeViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.layoutViewUI()
        self.setupViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.hitFetchRequest()
    }
    
    // MARK: -
    
    private func layoutViewUI() {
        self.title = "Home"
        self.infoLabel.text = ""
        self.infoContainer.isHidden = true

        self.activitySpinner.color = .white
        self.activitySpinner.hidesWhenStopped = true
        
        setupNavigationBar()
        setupNavigationBarButtons()
        
        self.tableView.registerNib(for: HQNewsArticleTableCell.self)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = .darkGray
        self.navigationController?.navigationBar.tintColor = .white
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .darkGray
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    private func setupNavigationBarButtons() {
        self.bookmarkButton = UIButton(type: UIButton.ButtonType.custom)
        
        self.bookmarkButton?.setImage(UIImage(systemName: "bookmark.square"), for: .normal)
        self.bookmarkButton?.setImage(UIImage(systemName: "bookmark.square.fill"), for: .selected)
        self.bookmarkButton?.addTarget(self, action: #selector(self.filterBookmarksTapped), for: .touchUpInside)
        if let bookmarkButton = self.bookmarkButton {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: bookmarkButton)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activitySpinner)
    }
    
    private func setupViewModel() {
        /// Skipping alert to show on screen error in label.
        /*
        self.viewModel.showAlertClosure = { [weak self] (message) in
            DispatchQueue.main.async {
                self?.showAlert(message)
            }
        }
         */

        self.viewModel.updateLoadingIndicatorClosure = { [weak self] () in
            let isFetching = self?.viewModel.isFetching ?? false
            DispatchQueue.main.async {
                if isFetching {
                    self?.activitySpinner.startAnimating()
                } else {
                    self?.activitySpinner.stopAnimating()
                }
            }
        }

        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let isFetching = self?.viewModel.isFetching, !isFetching {
                    if self?.viewModel.filterBookmarksActive() == true {
                        self?.infoLabel.text = "Seems you do not have any bookmarks!.\nPlease remove filter."
                        self?.infoButton.setTitle("Clear Filters", for: .normal)
                    } else {
                        self?.infoLabel.text = "Seems some occured.\nPlease try after sometime."
                        self?.infoButton.setTitle("Try again!", for: .normal)
                    }
                    
                    self?.tableView.isHidden = !((self?.viewModel.numberOfRowsForSection(at: 0) ?? 0) > 0)
                    self?.infoContainer.isHidden = ((self?.viewModel.numberOfRowsForSection(at: 0) ?? 0) > 0)
                } else {
                    self?.tableView.isHidden = false
                    self?.infoContainer.isHidden = true
                }
                self?.tableView.reloadData()
            }
        }
        
        viewModel.updateFilterBookmarkStatusClosure = { [weak self] () in
            self?.refreshBookbarButtonStatus()
        }
    }
    
    @IBAction
    func infoButtonTapped(_ sender: UIButton) {
        self.infoContainer.isHidden = true
        self.viewModel.actionButtonTapped()
    }
    
    @objc
    func filterBookmarksTapped() {
        self.viewModel.filterBookmarksTapped()
    }
    
    private func refreshBookbarButtonStatus() {
        DispatchQueue.main.async {
            self.bookmarkButton?.isSelected = self.viewModel.filterBookmarksActive()
        }
    }
}

extension HQHomeViewController {
    
    private func hitFetchRequest() {
        self.viewModel.fetchHomeData()
    }
    
}

extension HQHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.viewModel.section(at: indexPath.section)
        switch section {
        case .banner:
            return UITableViewCell()
        case .newsArticle:
            if let cell = tableView.dequeueReusableCell(withIdentifier: HQNewsArticleTableCell.reuseIdentifier, for: indexPath) as? HQNewsArticleTableCell {
                cell.index = indexPath.row
                cell.newsArticleViewModel = self.viewModel
                return cell
            }
        case .none:
            break
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsForSection(at: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = self.viewModel.section(at: indexPath.section)
        switch section {
        case .banner:
            break
        case .newsArticle:
            if let link = self.viewModel.fullArticleUrl(at: indexPath.row) {
                self.navigationDelegate?.homeNavigateTo(link: link, withTitle: self.viewModel.articleTitle(at: indexPath.row))
            }
        case .none:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.viewModel.section(at: indexPath.section)
        switch section {
        case .banner:
            return UITableView.automaticDimension
        case .newsArticle:
            return UITableView.automaticDimension
        case .none:
            break
        }
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = .white
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 0, width: headerView.frame.width-40, height: headerView.frame.height)
        label.font = .boldSystemFont(ofSize: 17.0)
        label.textColor = .black
        
        label.text = self.viewModel.headerTitle(at: section)
        
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = self.viewModel.section(at: section)
        if section == .newsArticle {
            return 30
        }
        return 0
    }
    
}
