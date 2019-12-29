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
    var module:Module = Module()
    var listParametreRecup:[Parametre] = [Parametre]()
    var idModule = ""
    
    var listParametre:[String]=["Acidité","Temperature","PH","Duree"]
   
///ViewLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Selection-----------------from : ", idModule)
        
        //Charge le coredata
        persistentContainer.loadPersistentStores { (persistentStoredescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
                
            else {
               self.recupModule()
                print("DEBUG: /Selection /  View Load / listParamtere . count : ", self.listParametreRecup.count)

            }
        }
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
    
///Recup module
    func recupModule() {
        
        // Création Fetch Request
        let fetchRequest: NSFetchRequest<Parametre> = Parametre.fetchRequest()
        
        // Paramétrage Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nom", ascending: true)]
        
        //Ajout d'un predicate pour spécifier la request
        let premierPredicate = NSPredicate(format: "module.nom == %@", idModule)
        //let secondPredicate = NSPredicate(format: "module.modele.nom", idModele)
        
        // Combiner les deux prédicats ci-dessus en un seul prédicat composé
        //let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [premierPredicate, secondPredicate])
        // let predicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType, subpredicates: [premierPredicate, secondPredicate])
        fetchRequest.predicate = premierPredicate
        
        
        // executes fetch
        listParametreRecup = try! persistentContainer.viewContext.fetch(fetchRequest)
    }
    
    
    ///Segue functions
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var disponible:Bool = true
        if (identifier == "Done"){
            for parametreParcours in self.listParametreRecup {
                if parametreParcours.module?.modele?.nom == self.idModele{
                    print("DEBUG: Selection / ShouldPerform/ Prametre Match" + (parametreParcours.module?.modele?.nom)! + self.idModele)
                    
                    if (parametreParcours.nom == listParametre[ParametrePickerView.selectedRow(inComponent: 0)])
                    {
                        disponible = false
                        print("DEBUG: Selection / ShouldPerform / matched / indisponible")
                        //TODO : signaler à l'utilisateur
                        
                    }
                }
            }
        }
        
        return disponible
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Cancel" {
            if let destinationVC = segue.destination as? ParametresAffichageTableViewController {
                //print("DEBUG: SelectionParametree/Cancel/idModele :", idModele)
                destinationVC.idModele = idModele
               // destinationVC.modele = modele
                destinationVC.idModule = idModule
            }
        }
        if segue.identifier == "Done" {
            //guard let indexPath = tableView.indexPathForSelectedRow else {return }
            //let parametre = fetchedResultsController.object(at: indexPath)
            
            if let destinationVC = segue.destination as? ParametresAffichageTableViewController {
                //print("DEBUG: SelectionParametre/SegueDone/idModele :", idModele)
                //print("DEBUG: SelectionParametre/SegueDone/idModule :", idModule)
                destinationVC.idModele = idModele
                //destinationVC.modele = modele
                destinationVC.idModule = idModule
                
                destinationVC.hasParametre = true
                //print("DEBUG: SelectionParametre/SegueDone/parametre du pickerView :", listParametre[ParametrePickerView.selectedRow(inComponent: 0)])
                destinationVC.param = listParametre[ParametrePickerView.selectedRow(inComponent: 0)]
            }
        }
        
    }
    
    

}
