//
//  mensualListadoViewController.swift
//  tpv
//
//  Created by chus on 30/3/16.
//  Copyright © 2016 LosBarkitos. All rights reserved.
//

import Cocoa
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}




class mensualListadoViewController: NSViewController, datosBBD2, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet var viewListado: NSView!
    @IBOutlet weak var mesNSTextField: NSTextField!
    @IBOutlet weak var tableview: NSTableView!
    @IBOutlet weak var mesComboBox: NSComboBox!
    @IBOutlet weak var mesNSview: NSView!
    @IBOutlet weak var imprimirButton: NSButton!
    @IBOutlet weak var cerrarButton : NSButton!
    @IBOutlet weak var cambiarMesButton: NSButton!
    
    // propiedades del recuadro de totales
    @IBOutlet weak var total_tickets: NSTextField!
    @IBOutlet weak var neto: NSTextField!
    @IBOutlet weak var IVA: NSTextField!
    @IBOutlet weak var bruto: NSTextField!
    
    
    var webService : webServiceCallApi2 = webServiceCallApi2()

    var numRegistros = 0
    var listado = [[String : AnyObject]]()
    
    var totalTickets : Int = 0 {
        didSet {
            self.total_tickets.stringValue = String(self.totalTickets)
        }
    }
    var totalBruto : Float = 0.0 {
        didSet {
            self.bruto.stringValue = (formato.string(from: self.totalBruto as NSNumber))!
        }
    }
    var totalNeto : Float = 0.0 {
        didSet {
            self.neto.stringValue = (formato.string(from: self.totalNeto as NSNumber))!
        }
    }
    var totalIVA : Float = 0.0 {
        didSet {
            self.IVA.stringValue = (formato.string(from: self.totalIVA as NSNumber))!
        }
    }
    
    let formato : NumberFormatter = NumberFormatter()
    
    @IBAction func cambiarMesPush(_ sender: NSButton) {
        
        self.mesNSTextField.isHidden = true
        self.mesNSview.isHidden = false
        self.imprimirButton.isEnabled = false
        sender.isHidden = true
        
    }
    @IBAction func imprimir(_ sender: NSButton) {
        
        self.imprimirButton.isHidden = true
        self.mesNSview.isHidden = true
        self.cerrarButton.isHidden = true
        let l : listadoImpreso = listadoImpreso()
        l.print(self.viewListado)
        self.imprimirButton.isHidden = false
        self.mesNSview.isHidden = false
        self.cerrarButton.isHidden = false

        
    }
    
    @IBAction func botonOkPushButton(_ sender: NSButton) {
        
        
        let mes = self.mesComboBox.indexOfSelectedItem + 1
        webService.MFlistadoMensual(mes, ano: 18)
        
        self.mesNSTextField.stringValue = self.mesComboBox.stringValue
        self.mesNSview.isHidden = true
        self.mesNSTextField.isHidden = false
        self.cambiarMesButton.isHidden = false
        self.imprimirButton.isEnabled = true
        
    }

    @IBAction func mesNsTextFieldPush(_ sender: NSTextField) {
        
        self.mesNSTextField.isHidden = true
        self.cambiarMesButton.isHidden = true
        self.mesNSview.isHidden = false
        self.imprimirButton.isEnabled = false
        
    }
    
    @IBAction func cerrarPush(_ sender: NSButton) {
        
        self.dismiss(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        formato.maximumFractionDigits = 2
        formato.minimumFractionDigits = 2
        formato.roundingMode = .halfEven

        self.mesNSview.isHidden = false
        self.mesNSTextField.isHidden = true
        self.cambiarMesButton.isHidden = true
        self.imprimirButton.isEnabled = false
        
        webService.delegate = self
    }
    
    func listadoMensualMF(_ respuesta : [String : AnyObject]) {
        //print("listadoMensualMF : \(respuesta)")
        var registro : [String : AnyObject] = [:]
        for (k,v) in respuesta {
            if k != "error" && k != "numero_dias" {
                registro["fecha"]    = v["fecha"] as! String as AnyObject?
                registro["cantidad"] = v["viajes"] as! Int as AnyObject?
                registro["base"]     = v["neto"] as! Float as AnyObject?
                registro["iva"]      = v["iva"] as! Float as AnyObject?
                registro["bruto"]    = v["total"] as! Float as AnyObject?
                
                self.listado.append(registro)
            }
        }
        // ordeno la lista por fecha
        self.listado.sort { (primero : [String : AnyObject], segundo : [String : AnyObject]) -> Bool in
            
            let pri : String = primero["fecha"] as! String
            let seg : String = segundo["fecha"] as! String
            let compPri = pri.components(separatedBy: "-")
            let compSeg = seg.components(separatedBy: "-")
            
            return  Int(compSeg[0]) > Int(compPri[0])
        }

        self.tableview.reloadData()
        
    }
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.listado.count 
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text : String = ""
        var celdaIdentificador : String = ""
        
        if self.listado.count > 0 {
            let item = self.listado[row]
            if tableColumn == tableView.tableColumns[0] {
                text = String(describing: item["fecha"]!)
                celdaIdentificador = "fechaID"
            } else if tableColumn == tableView.tableColumns[1] {
                self.totalTickets += item["cantidad"] as! Int
                text = String(describing: item["cantidad"]!)
                celdaIdentificador = "cantidadID"
            } else if tableColumn == tableView.tableColumns[2] {
                self.totalNeto += item["base"] as! Float
                text = formato.string(from: item["base"] as! NSNumber)!
                celdaIdentificador = "baseID"
            } else if tableColumn == tableView.tableColumns[3] {
                self.totalIVA += item["iva"] as! Float
                text = formato.string(from: item["iva"] as! NSNumber)!
                celdaIdentificador = "ivaID"
            } else {
                self.totalBruto += item["bruto"] as! Float
                text = formato.string(from: item["bruto"] as! NSNumber)!
                celdaIdentificador = "brutoID"
            }
        
        
            if let celda = tableView.make(withIdentifier: celdaIdentificador, owner: nil) as? NSTableCellView {
                celda.textField?.stringValue = text
                return celda
            }

        
        } else {
            return nil
        }

        return nil
    }
    
}
