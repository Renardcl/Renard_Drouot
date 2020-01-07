//
//  CelluleTableViewCell.swift
//  Renard_Drouot
//
//  Created by RENARD Clement on 29/12/2019.
//  Copyright © 2019 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData

//Protcole implémenté par Les Vues de la fonction Paramétrer pour permettre la suppression d'éléments
protocol YourCellDelegate : class {
    //Envoi une référence sur la cellule pour effectuer la suppression
    func didPressButton(cell : CelluleTableViewCell)
}

class CelluleTableViewCell: UITableViewCell {
    
    //Implémente le protocole
    var cellDelegate: YourCellDelegate?
    
    //Outlets
    @IBOutlet weak var DeleteButton: UIButton!
    @IBAction func buttonPressed(_ sender: UIButton) {
        //Appelle la fonction du protocole pour la suppression
        cellDelegate?.didPressButton(cell : self)
    }
    
    //Configuration d'une cellule Modele
    func configure(_ cell: UITableViewCell, at indexPath : IndexPath, modele:Modele){
        cell.textLabel?.text = modele.nom
    }
    
    //Configuration d'une cellule Module
    func configure(_ cell: UITableViewCell, at indexPath : IndexPath, module:Module){
        cell.textLabel?.text = module.nom
    }
    //Configuration d'une cellule Parametre
    func configure(_ cell: UITableViewCell, at indexPath : IndexPath, parametre:Parametre){
        cell.textLabel?.text = parametre.nom
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
