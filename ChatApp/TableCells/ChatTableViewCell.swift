//
//  ChatTableViewCell.swift
//  ChatApp
//
//  Created by Brandon Barooah on 1/10/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var postDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setChat(chat:Chat){
        userNameLabel.text = chat.userName ?? "Unknown"
        messageTextField.text = chat.text ?? ""
        postDateLabel.text = chat.datePosted ?? "Unknown"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
