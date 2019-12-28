//
//  SelectionParametreViewController.swift
//  Renard_Drouot
//
//  Created by RENARD Clement on 27/12/2019.
//  Copyright © 2019 RENARD Clement. All rights reserved.
//

import UIKit
import CoreData

class SelectionParametreViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var ParametrePickerView: UIPickerView!
    
    private let persistentContainer = NSPersistentContainer(name: "Renard_Drouot")
    
    var idModele = ""
    var modele:Modele = Modele()
    var idModule = ""
    
    var listParametre:[String]=["Acidité","Temperature","PH","Duree"]
   
///ViewLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEUBG: /SelectionParametre / ViewLoad / idModele :", idModele)
        print("DEUBG: /SelectionParametre / ViewLoad / idModule :", idModule)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
///PickerMethods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listParametre.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listParametre[row]
    }
    
    
///Segue functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Cancel" {
            if let destinationVC = segue.destination as? ParametresAffichageTableViewController {
                print("DEBUG: ListParametre/Cancel/idModele :", idModele)
                destinationVC.idModele = idModele
               // destinationVC.modele = modele
                destinationVC.idModule = idModule
            }
        }
        if segue.identifier == "Done" {
            //guard let indexPath = tableView.indexPathForSelectedRow else {return }
            //let parametre = fetchedResultsController.object(at: indexPath)
            
            if let destinationVC = segue.destination as? ParametresAffichageTableViewController {
                print("DEBUG: ListParametre/SegueDone/idModele :", idModele)
                print("DEBUG: ListParametre/SegueDone/idModule :", idModule)
                destinationVC.idModele = idModele
                //destinationVC.modele = modele
                destinationVC.idModule = idModule
                
                destinationVC.hasParametre = true
                print("DEBUG: ListParametre/SegueDone/parametre du pickerView :", listParametre[ParametrePickerView.selectedRow(inComponent: 0)])
                destinationVC.param = listParametre[ParametrePickerView.selectedRow(inComponent: 0)]
            }
        }
        
    }
    
    

}
