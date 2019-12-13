//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Kyle Jennings on 12/10/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    // MARK: - Properties
    var post: Post? {
        didSet {
            updateViews()
        }
    }

    // MARK: - Custom Functions
    func updateViews() {
        guard let post = post else {return}
      print(post.commentCount)
      DispatchQueue.main.async {
        self.postImageView.image = post.photo
        self.captionLabel.text = post.caption
        self.commentCountLabel.text = "\(post.commentCount)"
      }
    }
}
