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
    
    //Outlets
    @IBOutlet weak var ParametrePickerView: UIPickerView!
    
    //Variables de manipulation d'objets
    var module:Module = Module()
    var listParametresFromModule:[Parametre] = [Parametre]()
    
    //Navigation
    var idModele = ""
    var idModule = ""
    
    //PersistentContainer
    private let persistentContainer = NSPersistentContainer(name: "Renard_Drouot")
    
    //Liste de paramètres prédéfinies
    var listParametre:[String]=["Acidité","Temperature","PH","Duree"]
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Selection-----------------")
        
        //Chargement du coredata
        persistentContainer.loadPersistentStores { (persistentStoredescription, error) in
            if let error = error {
                print("ERROR : Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            }
                
            else {
                //Recuperation du module passé en paramètre
                self.recupModule()
                /// print("DEBUG: /Selection /  View Load / listParamtere . count : ", self.listParametreRecup.count)
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
    
///Récuperation du module passé en paramètre
    func recupModule() {
        
        // Création Fetch Request
        let fetchRequest: NSFetchRequest<Parametre> = Parametre.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "nom", ascending: true)]
        let predicate = NSPredicate(format: "module.nom == %@", idModule)
        fetchRequest.predicate = predicate
        
        //Execution du fetch
        listParametresFromModule = try! persistentContainer.viewContext.fetch(fetchRequest)
    }
    
    
///Segue functions
    //Controles a effectué avant de pouvoir effectuer le Segue
        //Test d'existence du paramètre dans le module
        //TODO : Message à l'utilisateur
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var disponible:Bool = true
        
        //Si l'utilisateur a fait un choix de nouveau paramètre, on verifie qu'il n'existe pas déja dans le module
        if (identifier == "Done"){
            for parametreParcours in self.listParametresFromModule {
                if parametreParcours.module?.modele?.nom == self.idModele{
                    ///print("DEBUG: Selection / ShouldPerform/ Prametre Match" + (parametreParcours.module?.modele?.nom)! + self.idModele)
                    
                    if (parametreParcours.nom == listParametre[ParametrePickerView.selectedRow(inComponent: 0)])
                    {
                        disponible = false
                        print("WARNING: Selection / ShouldPerform / matched / indisponible")
                        //TODO : signaler à l'utilisateur
                        
                    }
                }
            }
        }
        return disponible
    }
    
    //Passage d'argument dans les segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Cancel" {
            
            //Argument : nom du modèle + nom du module
            if let destinationVC = segue.destination as? ParametresAffichageTableViewController {
                ///print("DEBUG: SelectionParametree/Cancel/idModele :", idModele)
                destinationVC.idModele = idModele
                destinationVC.idModule = idModule
            }
        }
        
        if segue.identifier == "Done" {
            
            //Arguement : nom du modèle + nom du module + parametre + hasParametre=true
            if let destinationVC = segue.destination as? ParametresAffichageTableViewController {
                ///print("DEBUG: SelectionParametre/SegueDone/idModele :", idModele)
                ///print("DEBUG: SelectionParametre/SegueDone/idModule :", idModule)
                destinationVC.idModele = idModele
                destinationVC.idModule = idModule
                
                destinationVC.hasParametre = true
                destinationVC.param = listParametre[ParametrePickerView.selectedRow(inComponent: 0)]
            }
        }
    }
}
