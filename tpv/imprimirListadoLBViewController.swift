//
//  imprimirListadoLBViewController.swift
//  tpv
//
//  Created by Jesus Valladolid Rebollar on 5/4/16.
//  Copyright © 2016 LosBarkitos. All rights reserved.
//

import Cocoa

class imprimirListadoLBViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet var ViewListado: NSView!
    @IBOutlet weak var tableViewScroll: NSScrollView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var numero: NSTableColumn!

    @IBOutlet weak var tipoBarcaTableView: NSTableColumn!
    @IBOutlet weak var precioTableView: NSTableColumn!
    @IBOutlet weak var botonImprimirButton: NSButton!
    @IBOutlet weak var fechaTextField: NSTextField!
    @IBOutlet weak var salirNsButton: NSButton!
    @IBOutlet weak var boxTotalesNSBox: NSBox!
    @IBOutlet weak var totalTextField: NSTextField!
    @IBOutlet weak var numTicketsTextField: NSTextField!
    
    var fecha : String = ""
    var numTickets : Int = 0
    var total : Float = 0.0
    
    let alturaPagina : Int = 750
    
    var listadoTickets = [[String : AnyObject]]()
    let numLineas = 36
    var numPaginas = 1
    var paginaActual = 0

    @IBAction func botonImprimir(_ sender: NSButton) {
        self.botonImprimirButton.isHidden = true
        self.salirNsButton.isHidden = true
        
        if self.listadoTickets.count > self.numLineas {
            for _ in 2 ... numPaginas + 1 {
                sender.isHidden = true
                let l : listadoImpreso = listadoImpreso()
                l.print(self.ViewListado)
                
                if (paginaActual == numPaginas ) {
                }
                paginaActual += 1
                self.tableView.reloadData()
            }
        }
        self.boxTotalesNSBox.isHidden = false
        self.ViewListado.setNeedsDisplay(NSRect(x : 0, y : 0, width: 500, height : 775))
        let l : listadoImpreso = listadoImpreso()
        l.print(self.ViewListado)
        self.botonImprimirButton.isHidden = true
        self.salirNsButton.isHidden = true
        
        dismiss(self)
        
    }
    
    @IBAction func salirPushButton(_ sender: NSButton) {
        
        self.dismiss(self)
        
    }

    
    override func viewWillAppear() {
        self.fechaTextField.alignment = NSTextAlignment.natural
        self.fechaTextField.stringValue = self.fecha
        self.numTicketsTextField.stringValue = String(self.numTickets)
        self.totalTextField.stringValue = String(self.total)
        
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        numPaginas = self.numTickets / numLineas
        
        self.boxTotalesNSBox.isHidden = true
    
    }
    // Metodos del delegado de la tableview
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        // El numero de filas = 24 y es constante
        //return self.listadoTickets.count ?? 0
        return numLineas
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let formato : NumberFormatter = NumberFormatter()
        formato.maximumFractionDigits = 2
        formato.minimumFractionDigits = 2
        formato.roundingMode = .halfEven
        
        
        var text : String = ""
        var celdaIdentificador : String = ""
        // Item contiene el registro a meter en la tableView
        var item = [String : AnyObject]()
        var b : Bool = true
        
        if (row + (paginaActual * numLineas)) < self.listadoTickets.count {
            item = self.listadoTickets[row + (paginaActual * numLineas)]
        } else {
            
            b = false
            
        }
        
        if b {
            if tableColumn == tableView.tableColumns[0] { // Número
                text = String(item["numero"]! as! Int)
                celdaIdentificador = "numeroCellId"
            } else if tableColumn == tableView.tableColumns[1] { // punto_venta
                text = String(item["barca"]! as! String)
                celdaIdentificador = "tipoCellId"
            } else if tableColumn == tableView.tableColumns[2] { // precio
                text = formato.string(from: item["precio"] as! NSNumber)!
                celdaIdentificador = "precioCellId"
            }
            
        }
        
        if let celda = tableView.make(withIdentifier: celdaIdentificador, owner: nil) as? NSTableCellView {
            celda.textField?.stringValue = text

            return celda
        }
        return nil
    }
    
    
}
