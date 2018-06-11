//
//  ProfilFormViewController.swift
//  Eden Team Builder
//
//  Created by Sébastien Gilabert on 14/05/2018.
//  Copyright © 2018 Sébastien Gilabert. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import RealmSwift

class ProfilFormViewController: FormViewController
{
    static let PROFIL_VIEW_ID = "profilForm"
    
    var model: Personnage? = nil
    var parentController : PageViewController!
    var update: Bool = true
    //var errorDetected = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Valider", style: .plain, target: self, action: #selector(onValideButtonClick(sender:)))
        
        form +++ Section("Profil")
            <<< TextRow(){ row in
                row.title = "Nom"
                row.tag = "nom"
                row.placeholder = "Tapez votre nom ici"
                if(model != nil)
                {
                    row.value = model!.nom
                }
            }
            <<< ActionSheetRow<String>() {
                $0.title = "Faction"
                $0.tag = "faction"
                $0.selectorTitle = "Choisir sa faction"
                $0.options = Faction.toString()
                $0.value = "Jokers"    // initially selected
            }
            <<< ImageRow() { row in
                row.title = "Photo de profil"
                row.tag = "photo"
                row.useEditedImage = true
                row.sourceTypes = [.PhotoLibrary, .Camera]
                row.allowEditor = true
                row.clearAction = .yes(style: UIAlertActionStyle.destructive)
                if(model?.image != Data())
                {
                    row.value = UIImage(data: model!.image)
                }
            }
            .cellUpdate { cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            }
            
            +++ Section("Psy")
            <<< PhoneRow(){
                $0.title = "Psy"
                $0.tag = "psy"
                $0.value = String(model!.psy)
            }
            <<< PhoneRow(){
                $0.title = "Psy Rouge"
                $0.tag = "psyRed"
                $0.value = String(model!.psyRed)
            }
            <<< PhoneRow(){
                $0.title = "PSY CP"
                $0.tag = "psyCP"
                $0.value = String(model!.psyCP)
            }
            <<< PhoneRow(){
                $0.title = "PSY CP Rouge"
                $0.tag = "psyCPRed"
                $0.value = String(model!.psyCPRed)
            }
        
            +++ Section("Vigeur")
            <<< PhoneRow(){
                $0.title = "Viguer"
                $0.tag = "vig"
                $0.value = String(model!.vig)
            }
            <<< PhoneRow(){
                $0.title = "Vigueur Rouge"
                $0.tag = "vigRed"
                $0.value = String(model!.vigRed)
            }
            <<< PhoneRow(){
                $0.title = "VIG CP"
                $0.tag = "vigCP"
                $0.value = String(model!.vigCP)
            }
            <<< PhoneRow(){
                $0.title = "VIG CP Rouge"
                $0.tag = "vigCPRed"
                $0.value = String(model!.vigCPRed)
            }
        
            +++ Section("Combat")
            <<< PhoneRow(){
                $0.title = "Combat"
                $0.tag = "cbt"
                $0.value = String(model!.cbt)
            }
            <<< PhoneRow(){
                $0.title = "Combat Rouge"
                $0.tag = "cbtRed"
                $0.value = String(model!.cbtRed)
            }
            <<< PhoneRow(){
                $0.title = "CBT CP"
                $0.tag = "cbtCP"
                $0.value = String(model!.cbtCP)
            }
            <<< PhoneRow(){
                $0.title = "CBT CP Rouge"
                $0.tag = "cbtCPRed"
                $0.value = String(model!.cbtCPRed)
            }
        
            +++ Section("Rapidité")
            <<< PhoneRow(){
                $0.title = "Rapidité"
                $0.tag = "rap"
                $0.value = String(model!.rap)
            }
            <<< PhoneRow(){
                $0.title = "Rapidité Rouge"
                $0.tag = "rapRed"
                $0.value = String(model!.rapRed)
            }
            <<< PhoneRow(){
                $0.title = "RAP CP"
                $0.tag = "rapCP"
                $0.value = String(model!.rapCP)
            }
            <<< PhoneRow(){
                $0.title = "RAP CP Rouge"
                $0.tag = "rapCPRed"
                $0.value = String(model!.rapCPRed)
            }
        
            +++ Section("")
            <<< ButtonRow()
                {
                    $0.title = "Supprimer"
                    $0.tag = "buttonRemove"
                }
                .cellUpdate { cell, row in
                    if row.isValid
                    {
                        if self.update
                        {
                            cell.textLabel?.textColor = UIColor.red
                            cell.textLabel?.tintColor = UIColor.red
                        }
                        else
                        {
                            cell.textLabel?.textColor = UIColor.lightGray
                            cell.textLabel?.tintColor = UIColor.lightGray
                        }
                    }
                }
                .onCellSelection(self.onDeleteButtonClick)
    }
    
    func onDeleteButtonClick(cell: ButtonCellOf<String>, row: ButtonRow)
    {
        if update == false
        {
            return
        }
        
        let alert = UIAlertController(title: "Supprimer", message: "Êtes-vous sur de vouloir supprimer ce profil ?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Oui", style: .destructive, handler: { action in
            let realm = try! Realm()
            try! realm.write
            {
                realm.delete(self.model!)
                self.parentController.viewDidLoad()
                self.navigationController?.popViewController(animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @objc func onValideButtonClick(sender: UIBarButtonItem)
    {
        if model != nil
        {
            let realm = try! Realm()
            try! realm.write
            {
                for row in form.allRows
                {
            
                    if row.baseValue == nil && row.tag != "buttonRemove"
                    {
                        let alert = UIAlertController(title: "Erreur", message: "Veuillez remplir tous les champs !", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Valider", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true)
                        return
                    }
                    
                    if row.tag == "nom"
                    {
                        model!.nom = row.baseValue as! String
                    }
                    else if row.tag == "faction"
                    {
                        model!.faction = Faction.from(string: row.baseValue as! String)!
                    }
                    else if row.tag == "photo"
                    {
                        let data = UIImageJPEGRepresentation(row.baseValue as! UIImage, 1)!
                        model!.image = data
                    }
                    else if row.tag == "psy"
                    {
                        model!.psy = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "psyRed"
                    {
                        model!.psyRed = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "psyCP"
                    {
                        model!.psyCP = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "psyCPRed"
                    {
                        model!.psyCPRed = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "cbt"
                    {
                        model!.cbt = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "cbtRed"
                    {
                        model!.cbtRed = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "cbtCP"
                    {
                        model!.cbtCP = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "cbtCPRed"
                    {
                        model!.cbtCPRed = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "vig"
                    {
                        model!.vig = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "vigRed"
                    {
                        model!.vigRed = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "vigCP"
                    {
                        model!.vigCP = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "vigCPRed"
                    {
                        model!.vigCPRed = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "rap"
                    {
                        model!.rap = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "rapRed"
                    {
                        model!.rapRed = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "rapCP"
                    {
                        model!.rapCP = Int(row.baseValue as! String)!
                    }
                    else if row.tag == "rapCPRed"
                    {
                        model!.rapCPRed = Int(row.baseValue as! String)!
                    }
                }

                if update == false
                {
                    realm.add(model!)
                
                    let currentPageIndex = parentController.orderedViewControllers.count - 1
                    parentController.pageControlIndex = currentPageIndex
                    parentController.pageControl.currentPage = currentPageIndex
                    
                    parentController.viewDidLoad()
                }
            }
        
        }
        self.navigationController?.popViewController(animated: true)
    }
}
