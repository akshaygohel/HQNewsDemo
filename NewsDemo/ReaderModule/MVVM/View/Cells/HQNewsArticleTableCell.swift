//
//  HQNewsArticleTableCell.swift
//  NewsDemo
//
//  Created by Akshay Gohel on 2024-06-12.
//  Copyright © 2024 Husqvarna. All rights reserved.
//

import UIKit

class HQNewsArticleTableCell: UITableViewCell {
    
    @IBOutlet
    private weak var containerView: UIView!
    
    @IBOutlet
    private weak var bookmarkImageView: UIImageView!
    
    @IBOutlet
    private weak var newsImageView: HQImageView!
    
    @IBOutlet
    private weak var titleLabel: UILabel!
    
    @IBOutlet
    private weak var contentLabel: UILabel!
    
    var index: Int?
    
    var newsArticleViewModel: HQNewArticleViewModelProtocol? {
        didSet {
            self.updateCellData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.updateUI()
    }
    
    override var reuseIdentifier: String? {
        return "HQNewsArticleTableCell"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension HQNewsArticleTableCell {
    private func updateUI() {
        // Set font, color, etc.
        self.containerView.layer.cornerRadius = 5.0
        self.containerView.layer.masksToBounds = true
        
        self.newsImageView.layer.cornerRadius = 5.0
        self.newsImageView.layer.masksToBounds = true
    }
    
    private func updateCellData() {
        if let newsArticleViewModel = self.newsArticleViewModel, let index = index {
            self.newsImageView.loadImage(from: newsArticleViewModel.articleImageUrl(at: index), contentMode: .scaleAspectFill) { [weak self] image in
                guard let weakSelf = self else { return }
                DispatchQueue.main.async {
                    weakSelf.newsImageView.isHidden = (image == nil)
                }
            }
            
            self.titleLabel.text = newsArticleViewModel.articleTitle(at: index)
            self.contentLabel.text = newsArticleViewModel.articleContent(at: index)
            self.bookmarkImageView.isHighlighted = newsArticleViewModel.isBookmarked(at: index)
        } else {
            self.newsImageView.image = nil
            self.newsImageView.loadImage(from: nil)
            
            self.titleLabel.text = ""
            self.contentLabel.text = ""
            
            self.newsImageView.isHidden = true
            
            self.bookmarkImageView.isHighlighted = false
        }
    }
}
