//
//  LibraryBookListTableViewCell.swift
//  BookSearch
//
//  Created by Stuart on 25/05/2016.
//  Copyright © 2016 Stuart. All rights reserved.
//

import UIKit

class LibraryBookListTableViewCell: UITableViewCell {

    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
