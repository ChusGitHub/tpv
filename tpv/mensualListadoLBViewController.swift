//
//  mensualListadoLBViewController.swift
//  tpv
//
//  Created by Jesus Valladolid Rebollar on 7/4/16.
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


class mensualListadoLBViewController: NSViewController, datosBDD_LB2, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet var viewListado: NSView!
    @IBOutlet weak var tableview: NSTableView!
    @IBOutlet weak var mesNsTextView: NSTextField!
    @IBOutlet weak var mesNsView: NSView!
    @IBOutlet weak var botonOkPush: NSButton!
    @IBOutlet weak var mesComboBox: NSComboBox!
    @IBOutlet weak var cerrarButton: NSButton!
    @IBOutlet weak var imprimirButton: NSButton!
    @IBOutlet weak var cambiarMesButton: NSButton!
    
    // propiedades del cuadro de totales
    @IBOutlet weak var totalNsView: NSBox!
    @IBOutlet weak var brutoMensualNsTextField: NSTextField!
    @IBOutlet weak var totalTicketsNsTextField: NSTextField!
    @IBOutlet weak var ivaTotalNsTextField: NSTextField!
    @IBOutlet weak var netoNsTextField: NSTextField!
    
    var webService : webServiceCallApiLB2 = webServiceCallApiLB2()
    
    var numRegistros = 0
    var listado = [[String : AnyObject]]()
    
    var totalTickets : Int = 0 {
        didSet {
            self.totalTicketsNsTextField.stringValue = String(self.totalTickets)
        }
    }
    
    var totalBruto : Float = 0.0 {
        didSet {
            self.brutoMensualNsTextField.stringValue = (formato.string(from: self.totalBruto as NSNumber))!
        }
    }
    
    var totalNeto : Float = 0.0 {
        didSet {
            self.netoNsTextField.stringValue = (formato.string(from: self.totalNeto as NSNumber))!
        }
    }
    
    var totalIVA : Float = 0.0 {
        didSet {
            self.ivaTotalNsTextField.stringValue = (formato.string(from: self.totalIVA as NSNumber))!
        }
    }
    
    let formato : NumberFormatter = NumberFormatter()
    
    
    @IBAction func cambiarMesPush(_ sender: NSButton) {
        
        self.mesNsTextView.isHidden = true
        self.mesNsView.isHidden = false
        self.imprimirButton.isEnabled = false
        sender.isHidden = true
        
    }
    @IBAction func imprimir(_ sender: NSButton) {
        
        self.imprimirButton.isHidden = true
        self.mesNsView.isHidden = true
        self.cerrarButton.isHidden = true
        let l : listadoImpreso = listadoImpreso()
        l.print(self.viewListado)
        self.imprimirButton.isHidden = false
        self.mesNsView.isHidden = false
        self.cerrarButton.isHidden = false
        
        
    }
    
    @IBAction func botonOkPushButton(_ sender: NSButton) {
        
        
        let mes = self.mesComboBox.indexOfSelectedItem + 1
        webService.LBlistadoMensualB(mes, ano: 18)
        
        self.mesNsTextView.stringValue = self.mesComboBox.stringValue
        self.mesNsView.isHidden = true
        self.mesNsTextView.isHidden = false
        self.cambiarMesButton.isHidden = false
        self.imprimirButton.isEnabled = true
        
    }
    
    @IBAction func mesNsTextFieldPush(_ sender: NSTextField) {
        
        self.mesNsTextView.isHidden = true
        self.cambiarMesButton.isHidden = true
        self.mesNsView.isHidden = false
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
        
        self.mesNsView.isHidden = false
        self.mesNsTextView.isHidden = true
        self.cambiarMesButton.isHidden = true
        self.imprimirButton.isEnabled = false
        
        webService.delegate = self
    }
    
    func listadoMensualLB(_ respuesta : [String : AnyObject]) {
        
        var registro : [String : AnyObject] = [:]
        for (k,v) in respuesta {
            if k != "error" && k != "numero_dias" {
                registro["fecha"]    = v["fecha"] as! String as AnyObject?
                registro["cantidad"] = v["viajes"] as! Int as AnyObject?
                registro["base"]     = v["neto"] as! NSNumber
                //registro["base"]     = v["neto"] as! Float as AnyObject?
                registro["iva"]      = v["iva"] as! NSNumber
                //registro["iva"]      = v["iva"] as! Float as AnyObject?
                registro["bruto"]    = v["total"] as! NSNumber
                //registro["bruto"]    = v["total"] as! Float as AnyObject?
                
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
            //print(item["bruto"])
            if tableColumn == tableView.tableColumns[0] {
                text = String(describing: item["fecha"]!)
                celdaIdentificador = "fechaID"
            } else if tableColumn == tableView.tableColumns[1] {
                self.totalTickets += item["cantidad"] as! Int
                text = String(describing: item["cantidad"]!)
                celdaIdentificador = "cantidadID"
            } else if tableColumn == tableView.tableColumns[2] {
                //self.totalNeto += item["base"] as! Float
                self.totalNeto += Float(item["base"] as! NSNumber)
                text = formato.string(from: item["base"] as! NSNumber)!
                celdaIdentificador = "baseID"
            } else if tableColumn == tableView.tableColumns[3] {
                //self.totalIVA += item["iva"] as! Float
                self.totalIVA += Float(item["iva"] as! NSNumber)
                text = formato.string(from: item["iva"] as! NSNumber)!
                celdaIdentificador = "ivaID"
            } else {
                //self.totalBruto += item["bruto"] as! Float
                self.totalBruto += Float(item["bruto"] as! NSNumber)
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
