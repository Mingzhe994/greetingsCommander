//
//  BookListTableViewCell.swift
//  BookSearch
//
//  Created by Stuart on 11/05/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//

import UIKit

class BookListTableViewCell: UITableViewCell {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookSubtitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
