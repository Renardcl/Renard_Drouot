//
//  UtilisationModeleTableViewCell.swift
//  Renard_Drouot
//
//  Created by YGGTorrent on 06/01/2020.
//  Copyright © 2020 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData

protocol UtilisationCellDelegate : class {
    //func didPressButton(cell : CelluleTableViewCell)
}

class UtilisationModeleTableViewCell: UITableViewCell {
    
    var cellDelegate : UtilisationCellDelegate?
    
    @IBOutlet weak var cellLabel: UILabel!
    
    @IBOutlet weak var TheoriqueTextField: UITextField!
    
    @IBOutlet weak var ReelTextField: UITextField!
    
    
    //Configuration d'une cellule Modele
    func configure(_ cell: UITableViewCell, at indexPath : IndexPath, parametre:Parametre){
        
        cellLabel.text = parametre.nom
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
