//
//  CelluleTableViewCell.swift
//  Renard_Drouot
//
//  Created by RENARD Clement on 29/12/2019.
//  Copyright © 2019 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData

protocol YourCellDelegate : class {
    func didPressButton(cell : CelluleTableViewCell)
}

class CelluleTableViewCell: UITableViewCell {
    
    var cellDelegate: YourCellDelegate?
    
    @IBOutlet weak var DeleteButton: UIButton!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
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
