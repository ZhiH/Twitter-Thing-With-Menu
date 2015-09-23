//
//  MentionCell.swift
//  Twitter
//
//  Created by Zhi Huang on 9/22/15.
//  Copyright (c) 2015 Zhi Huang. All rights reserved.
//

import UIKit

class MentionCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!

    var tweet: Tweet! {
        didSet {
            let url = tweet.user?.profileImageUrl
            nameLabel.text = tweet.user?.name
            tweetContentLabel.text = tweet.text
            dateLabel.text = tweet.formattedCreatedAtString
            profileImageView.setImageWithURL(NSURL(string: url!))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
