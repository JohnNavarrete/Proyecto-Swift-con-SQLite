//
//  ViewController.swift
//  appTask
//
//  Created by John P. Navarrete on 23/12/21.
//  Copyright © 2021 John P. Navarrete. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {

  let SQLITE_TRANSINTE = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    
    @IBOutlet weak var textNombre: UITextField!
    @IBOutlet weak var textDescripcion: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textBuscar: UITextField!
    @IBOutlet weak var labelNueva: UILabel!
    @IBOutlet weak var botonPlus: UIButton!
    @IBOutlet weak var labelBorrar: UILabel!
    @IBOutlet weak var botonBorrar: UIButton!
    @IBOutlet weak var botonAtras: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.layer.cornerRadius = 20.0
        
        Hidden()
        Actu()
        
    }
    
    @IBAction func botonAgregar(_ sender: Any) {
        
        noHidden()
        
    }
    
    func Hidden(){
        textNombre.isHidden = true
        textDescripcion.isHidden = true
        botonAtras.isHidden = true
        
        labelBorrar.isHidden = false
        botonBorrar.isHidden = false
        labelNueva.isHidden = false
        botonPlus.isHidden = false
    }
    
    func noHidden(){
        textNombre.isHidden = false
        textDescripcion.isHidden = false
        botonAtras.isHidden = false
        
        labelBorrar.isHidden = true
        botonBorrar.isHidden = true
        labelNueva.isHidden = true
        botonPlus.isHidden = true
        
        textNombre.center.x = self.view.frame.width - 50
        UIView.animate(withDuration: 0.6, animations: {
            self.textNombre.center.x = self.view.frame.width / 2
        })
        
        textDescripcion.center.x = self.view.frame.width - 50
        UIView.animate(withDuration: 0.6, animations: {
            self.textDescripcion.center.x = self.view.frame.width / 2
        })
        
    }
    
    @IBAction func botonAtras(_ sender: Any) {
        Hidden()
    }
    
    
    @IBAction func DeleteAll(_ sender: Any) {
        
        let deleteStatementString = "DELETE FROM TEMP ;"
        
        var deleteStatement : OpaquePointer?
        
        if sqlite3_prepare_v2(dbQueue, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("DeleteAll successfully")
            }else{
                print("Error en al eliminar todas las tareas")
            }
        }
        
        sqlite3_finalize(deleteStatement)
        Actu()
    }
    
    func Actu() {
        
        let selectStatementString = "SELECT TEMPCOLUMN1, TEMPCOLUMN2 FROM TEMP"
        
        var selectStateQuery : OpaquePointer?
        var sShowData : String!
        
        sShowData = ""
        
        if sqlite3_prepare_v2(dbQueue, selectStatementString, -1, &selectStateQuery, nil) == SQLITE_OK
        {
            while sqlite3_step(selectStateQuery) == SQLITE_ROW {
                sShowData += "-" + String(cString: sqlite3_column_text(selectStateQuery, 0)) + "\n" + String(cString: sqlite3_column_text(selectStateQuery, 1)) + "\n\n"
            }
            sqlite3_finalize(selectStateQuery)
        }
        
        textView.text = sShowData ?? ""
    }

    @IBAction func botonRefresh(_ sender: Any) {
        
        let selectStatementString = "SELECT TEMPCOLUMN1, TEMPCOLUMN2 FROM TEMP"
        
        var selectStateQuery : OpaquePointer?
        var sShowData : String!
        
        sShowData = ""
        
        if sqlite3_prepare_v2(dbQueue, selectStatementString, -1, &selectStateQuery, nil) == SQLITE_OK
        {
            while sqlite3_step(selectStateQuery) == SQLITE_ROW {
                sShowData += "-" + String(cString: sqlite3_column_text(selectStateQuery, 0)) + "\n" + String(cString: sqlite3_column_text(selectStateQuery, 1)) + "\n\n"
            }
            sqlite3_finalize(selectStateQuery)
        }
        
        textView.text = sShowData ?? ""
    }
    
    
    @IBAction func btnSalvar(_ sender: Any) {
        //  INSERT
        let insertStatementString = "INSERT INTO TEMP (TEMPCOLUMN1, TEMPCOLUMN2) VALUES (?, ?);"
        
        var insertStatementQuery : OpaquePointer?
        
        if (textNombre.text == "" || textDescripcion.text == "")
        {

            textNombre.layer.borderWidth = 2
            textNombre.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            textDescripcion.layer.borderWidth = 2
            textDescripcion.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            
            let alert = UIAlertController(title: "Error al guardar la tarea", message: "Algun campo no esta llenado", preferredStyle: .alert)
            let okAlert = UIAlertAction(title: "Ok", style: .default, handler: {(alert:UIAlertAction!) -> Void in})
            alert.addAction(okAlert)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            
            if (sqlite3_prepare_v2(dbQueue, insertStatementString, -1, &insertStatementQuery, nil)) == SQLITE_OK
            {
                sqlite3_bind_text(insertStatementQuery, 1, textNombre.text ?? "", -1, SQLITE_TRANSINTE)
                sqlite3_bind_text(insertStatementQuery, 2, textDescripcion.text ?? "", -1, SQLITE_TRANSINTE)
                
                if sqlite3_step(insertStatementQuery) == SQLITE_DONE{
                    textNombre.text = ""
                    textDescripcion.text = ""
                    
                    textNombre.becomeFirstResponder()
                    print("Successfully inserted")
                }else {
                    print("Error")
                }
                sqlite3_finalize(insertStatementQuery)
            }
            
            let selectStatementString = "SELECT TEMPCOLUMN1, TEMPCOLUMN2 FROM TEMP"
            
            var selectStateQuery : OpaquePointer?
            var sShowData : String!
            
            sShowData = ""
            
            if sqlite3_prepare_v2(dbQueue, selectStatementString, -1, &selectStateQuery, nil) == SQLITE_OK
            {
                while sqlite3_step(selectStateQuery) == SQLITE_ROW {
                    sShowData += "-" + String(cString: sqlite3_column_text(selectStateQuery, 0)) + "\n" + String(cString: sqlite3_column_text(selectStateQuery, 1)) + "\n\n"
                }
                sqlite3_finalize(selectStateQuery)
            }
            
            textView.text = sShowData ?? ""
            
            Hidden()
        }
        
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        
        var tareaNombre = textBuscar.text
        
        let deleteStatementString = "DELETE FROM TEMP WHERE TEMPCOLUMN1 = " + "'" + tareaNombre! + "';"
        
        var deleteStatement : OpaquePointer?
        
        if sqlite3_prepare_v2(dbQueue, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Delete successfully")
                print(tareaNombre)
            }else{
                print("Error Nel")
            }
        }
        
        sqlite3_finalize(deleteStatement)
        Actu()
        
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        
        var tareaNombre = textBuscar.text
        
        let queryStatementString = "SELECT * FROM TEMP WHERE TEMPCOLUMN1 = " + "'" + tareaNombre! + "';"
        
        var queryStatement : OpaquePointer?
        
        var sShowData = ""
        
        if sqlite3_prepare_v2(dbQueue, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                print("Share successfully")
                print(tareaNombre)
                
                sShowData = "-" + String(cString: sqlite3_column_text(queryStatement, 0)) + "\n" + String(cString: sqlite3_column_text(queryStatement, 1)) + "\n\n"
                
            }else{
                print("Error Nel")
            }
        }
        
        textView.text = sShowData ?? ""
        
        sqlite3_finalize(queryStatement)
    }

}

