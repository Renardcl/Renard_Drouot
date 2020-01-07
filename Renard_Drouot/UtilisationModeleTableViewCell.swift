//
//  UtilisationModeleTableViewCell.swift
//  Renard_Drouot
//
//  Created by Renard Clément on 06/01/2020.
//  Copyright © 2020 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData

//Protcole implémenté par Les Vues de la fonction Utiliser pour permettre le remplissage et l'actualisation des textField : Théorique et Réel
protocol UtilisationCellDelegate : class {
    //Envoi une référence sur la cellule et un booléen indiquant si il s'agit du textField Reel ou theorique
    func textFieldChanged(cell : UtilisationModeleTableViewCell, reel:Bool)
}

class UtilisationModeleTableViewCell: UITableViewCell {
    
    //Implémente le protocole
    var cellDelegate : UtilisationCellDelegate?
    
    //Outlets
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var TheoriqueTextField: UITextField!
    @IBAction func TheoriqueDidChange(_ sender: UITextField)
    {
        ///print("DEBUG :  Theorique Changed  ---------------------------")
        cellDelegate?.textFieldChanged(cell: self, reel: false)
    }

    @IBOutlet weak var ReelTextField: UITextField!
    @IBAction func ReelDidChange(_ sender: UITextField)
    {
                cellDelegate?.textFieldChanged(cell: self, reel: false)
    }
    
    //Configuration d'une cellule Modele
    func configure(_ cell: UITableViewCell, at indexPath : IndexPath, parametre:Parametre){
        cellLabel.text = parametre.nom
        TheoriqueTextField.text = parametre.theorique
        ReelTextField.text = parametre.reel
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        TheoriqueTextField.addTarget(self, action: #selector(UtilisationModeleTableViewCell.TheoriqueDidChange(_:)),                            for: .editingChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
