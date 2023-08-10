//
//  WordCell.swift
//  WorldScramble-HackingWithSwift
//
//  Created by Mert Deniz Akbaş on 9.08.2023.
//

import UIKit

class WordCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateCell(title: String?) {
        titleLabel.text = title
    }


}
