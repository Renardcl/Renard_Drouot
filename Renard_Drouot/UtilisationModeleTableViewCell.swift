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
    func textFieldChanged(cell : UtilisationModeleTableViewCell)
}

class UtilisationModeleTableViewCell: UITableViewCell {
    
    var cellDelegate : UtilisationCellDelegate?
    
    @IBOutlet weak var cellLabel: UILabel!
    
    @IBOutlet weak var TheoriqueTextField: UITextField!
    
    @IBAction func TheoriqueDidChange(_ sender: UITextField) {
        print("DEBUG :  Theorique Changed  ---------------------------")
        cellDelegate?.textFieldChanged(cell: self)
        
    }
    
    
    @IBOutlet weak var ReelTextField: UITextField!
    
    
    //Configuration d'une cellule Modele
    func configure(_ cell: UITableViewCell, at indexPath : IndexPath, parametre:Parametre){
        
        cellLabel.text = parametre.nom
        TheoriqueTextField.text = parametre.theorique
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        TheoriqueTextField.addTarget(self, action: #selector(UtilisationModeleTableViewCell.TheoriqueDidChange(_:)),
                            for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
