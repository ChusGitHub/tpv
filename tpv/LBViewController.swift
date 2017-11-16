//
//  LBViewController.swift
//  tpv
//
//  Created by chus on 6/1/16.
//  Copyright © 2016 LosBarkitos. All rights reserved.
//

import Cocoa

public var viajes : [Viaje] = []
public var viajesB: [Viaje] = []
public var numeroVia : Int = 0
public var TP : Int = 0 // tipo de barca

public let MARINAFERRY  = 1
public let MARINAFERRY2 = 5
public let LOSBARKITOS  = 2

public let BARKITO   = 1
public let BARCA     = 2
public let GOLD      = 3

class LBViewController: NSViewController, datosBDD_LB, datosBDD_R, datosBDD_LS, NSTableViewDataSource, NSTableViewDelegate {

    var viaje : Viaje = Viaje()
    var reservas : [Int] = [0,0,0]
    var tipoReserva : Int = 0
    var numeroReserva : Int = 0

    var webService         : webServiceCallAPI_LB = webServiceCallAPI_LB()
    var webServiceReservas : webServiceCallApiR = webServiceCallApiR()
    var webServiceSalidas  : webServiceCallApiLS = webServiceCallApiLS()
    
    var listadoViajes = [[String : AnyObject]]()
    var listadoViajesB = [[String : AnyObject]]()
 //   var listAux = [[String : AnyObject]]()
    var listadoMensual = [[String : AnyObject]]()
    var listadoSalidas = [[String : AnyObject]]()
    var diaHoy = (dia : 1, mes : 1, año : 1)
    
    var via : Viaje = Viaje()
    
    var blanco : Bool = true
    
    let formato : NumberFormatter = NumberFormatter()
    
    let printInfo : NSPrintInfo = NSPrintInfo.shared()
    
    let color : CGColor = NSColor(red: 200, green: 0, blue: 0, alpha: 0.3).cgColor
    let colorB: CGColor = NSColor(red: 200, green: 0, blue: 0, alpha: 0.6).cgColor
    
    
    ///////////////////////////////////////////
    // CAMPOS DEL TICKET A IMPRIMIR
    /// Campos del Ticket a imprimir
   
    @IBOutlet weak var viajeNSView                  : NSView!
    @IBOutlet weak var fechaTicketNSTextField       : NSTextField!
    @IBOutlet weak var numeroTicketNSTextField      : NSTextField!
    @IBOutlet weak var reservaTicketNSTextField     : NSTextField!
    @IBOutlet weak var descripcionTicketNSTextField : NSTextField!
    @IBOutlet weak var baseTicketNSTextField        : NSTextField!
    @IBOutlet weak var ivaTicketNSTextField         : NSTextField!
    @IBOutlet weak var totalEurosTicketNSTextField: NSTextField!
    
    ///////////////////////////////////////////////////////////////////
  
    @IBOutlet weak var checkNegro: NSButton!
    
    //////////////////////////////////////////////////////
    
    @IBOutlet weak var ticketNSBox: NSBox!
    @IBOutlet weak var barkitosNSButton: NSButton!
    @IBOutlet weak var barcaNSButton: NSButton!
    @IBOutlet weak var electricaNSButton: NSButton!
    @IBOutlet weak var goldNSButton: NSButton!
    @IBOutlet weak var preciosNSBox: NSBox!
    
    
    //////////////////////////////////////////////////////
    // BOTONES DE LAS SALIDAS
    
    @IBOutlet weak var salidasBarkitosNSButton: NSButton!
    @IBOutlet weak var salidasGoldNSButton: NSButton!
    @IBOutlet weak var salidasBarcasNSButton: NSButton!
    
    
    @IBAction func botonSalidasNSButton(_ sender: NSButton) {
        
        webServiceSalidas.obtenerListadoSalidas(sender.tag)
        
    }
    
    //////////////////////////////////////////////////////
    
    @IBAction func tipoBarcaNSButton(_ sender: NSButton) {
        
        webService.LBreservasDia()
        
        self.ticketNSBox.isHidden = true
        self.preciosNSBox.isHidden = false
        viaje.tipoBarca = sender.tag
        webServiceReservas.LBnumeroReserva(sender.tag - 1)
        self.numeroReserva = self.reservas[sender.tag - 1]
        self.tipoReserva = sender.tag
    }
    
    @IBAction func precioNSButton(_ sender: NSButton) {
        
        viaje.puntoVenta = MARINAFERRY
        viaje.precio = Float(sender.title)!
        viaje.blanco = true
        
        self.preciosNSBox.isHidden = true
        self.ticketNSBox.isHidden = false
  
        if let precio = Float(sender.title) {
            webService.LBinsertar_viaje(precio, tipo: viaje.tipoBarca, blanco: 1)
        }
        
       
    }

    
    @IBAction func cancelarPrecioPush(_ sender: NSButton) {
        
        self.preciosNSBox.isHidden = true
        self.ticketNSBox.isHidden = false
        viaje.tipoBarca = 0
    }
    
    ///////////////////////////////////////////////////////
    @IBOutlet var viewLB: NSView!
    @IBOutlet weak var listadoView: NSView!
    @IBOutlet weak var listadoTableView: NSTableView!
 
    @IBOutlet weak var inicioNSDatePicker: NSDatePicker!
    @IBOutlet weak var finalNSDatePicker: NSDatePicker!
    
    @IBOutlet weak var listarNSPushButton: NSButton!
    
    
    // Resumen de los listados - Afecta a la Celia
    @IBOutlet weak var resumenNSBox: NSBox!
    @IBOutlet weak var numTickets: NSTextField!
    @IBOutlet weak var total: NSTextField!
    @IBOutlet weak var media: NSTextField!
    @IBOutlet weak var fecha: NSTextField!
    
    // Resumen de los listados total
    var numTicketsTotal : Int?
    var totalTotal : Float?
    ///////////////////////////////////////


    @IBAction func checkNegro(_ sender: NSButton) {
       
        if self.checkNegro.state == NSOnState {
            self.blanco = false
            self.view.layer?.backgroundColor = self.color
            self.listarNSButton(self.listarNSPushButton)
        } else {
            self.blanco = true
            self.view.layer?.backgroundColor = self.colorB
            self.listarNSButton(self.listarNSPushButton)
        }
    }
    
    @IBAction func swich(_ sender: NSSegmentedControl) {
        
         
    }
    
    @IBAction func listarNSButton(_ sender: NSButton) {
        
        let formato = DateFormatter()
        
        formato.dateFormat = "dd"
        let diaI : String = formato.string(from: inicioNSDatePicker.dateValue)
        let diaF : String = formato.string(from: finalNSDatePicker.dateValue)
        formato.dateFormat = "MM"
        let mesI : String = formato.string(from: inicioNSDatePicker.dateValue)
        let mesF : String = formato.string(from: finalNSDatePicker.dateValue)
        
        formato.dateFormat = "yy"
        let añoI : String = formato.string(from: inicioNSDatePicker.dateValue)
        let añoF : String = formato.string(from: finalNSDatePicker.dateValue)
        
        if self.blanco == true {
            webService.LBlistadoB(Int(diaI)!, mesI: Int(mesI)!, anyoI: Int(añoI)!, diaF: Int(diaF)!, mesF: Int(mesF)!, anyoF: Int(añoF)!)
        
            webService.LBestadisticasB(Int(diaI)!, mesI: Int(mesI)!, anyoI: Int(añoI)!, diaF: Int(diaF)!, mesF: Int(mesF)!, anyoF: Int(añoF)!)
            //print(self.diaHoy)
            webService.LBestadisticasTotalesB(Int(diaI)!, mesI: Int(mesI)!, anyoI: Int(añoI)!, diaF: Int(diaF)!, mesF: Int(mesF)!, anyoF: Int(añoF)!)

            
        } else {
            webService.LBlistado(Int(diaI)!, mesI: Int(mesI)!, anyoI: Int(añoI)!, diaF: Int(diaF)!, mesF: Int(mesF)!, anyoF: Int(añoF)!)
            
            webService.LBestadisticas(Int(diaI)!, mesI: Int(mesI)!, anyoI: Int(añoI)!, diaF: Int(diaF)!, mesF: Int(mesF)!, anyoF: Int(añoF)!)
            webService.LBestadisticasTotales(Int(diaI)!, mesI: Int(mesI)!, anyoI: Int(añoI)!, diaF: Int(diaF)!, mesF: Int(mesF)!, anyoF: Int(añoF)!)


        }

    }
    
    @IBAction func contadores0PushButton(_ sender: Any) {
    
        webService.cierre()
    
    }
    
    @IBAction func imprimirResumenPushButton(_ sender: NSButton) {
        self.resumenNSBox.isHidden = false
        self.imprimirResumen()
        self.resumenNSBox.isHidden = true
    }
    
    
    // TABLE VIEW DE LAS SALIDAS
    
    @IBOutlet weak var listadoSalidasNSTableView: NSTableView!
    
    
    ///////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preciosNSBox.isHidden = true
        self.ticketNSBox.isHidden = false
        
        
        
        // Se empieza con blanco

        self.checkNegro.state = NSOffState
        self.blanco = true
        
        formato.maximumFractionDigits = 2
        formato.minimumFractionDigits = 2
        formato.roundingMode = .halfEven
        
        self.resumenNSBox.isHidden = true

        self.diaHoy = buscarFechaHoy()
        
        self.listadoTableView.dataSource = self
        self.listadoTableView.delegate   = self
        
        self.listadoSalidasNSTableView.dataSource   = self
        self.listadoSalidasNSTableView.delegate     = self
        
        webService.delegate         = self
        webServiceReservas.delegate = self
        webServiceSalidas.delegate  = self
        
        if self.blanco == true {
            webService.LBlistadoB(self.diaHoy.dia, mesI: self.diaHoy.mes, anyoI: self.diaHoy.año, diaF: self.diaHoy.dia, mesF: self.diaHoy.mes, anyoF: self.diaHoy.año)
            webService.LBestadisticasB(self.diaHoy.dia, mesI:self.diaHoy.mes, anyoI: self.diaHoy.año, diaF: self.diaHoy.dia, mesF: self.diaHoy.mes, anyoF: self.diaHoy.año)
            webService.LBestadisticasTotalesB(self.diaHoy.dia, mesI:self.diaHoy.mes, anyoI: self.diaHoy.año, diaF: self.diaHoy.dia, mesF: self.diaHoy.mes, anyoF: self.diaHoy.año)

        } else {
            webService.LBlistado(self.diaHoy.dia, mesI: self.diaHoy.mes, anyoI: self.diaHoy.año, diaF: self.diaHoy.dia, mesF: self.diaHoy.mes, anyoF: self.diaHoy.año)
            webService.LBestadisticas(self.diaHoy.dia, mesI:self.diaHoy.mes, anyoI: self.diaHoy.año, diaF: self.diaHoy.dia, mesF: self.diaHoy.mes, anyoF: self.diaHoy.año)
            webService.LBestadisticasTotales(self.diaHoy.dia, mesI:self.diaHoy.mes, anyoI: self.diaHoy.año, diaF: self.diaHoy.dia, mesF: self.diaHoy.mes, anyoF: self.diaHoy.año)

            
        }
        
        webService.LBreservasDia()
        
//  /      webService.LBestadisticasTotalesB(self.diaHoy.dia, mesI:self.diaHoy.mes, anyoI: self.diaHoy.año, diaF: self.diaHoy.dia, mesF: self.diaHoy.mes, anyoF: self.diaHoy.año)
        
        
        self.inicioNSDatePicker.dateValue = Date()
        self.finalNSDatePicker.dateValue = Date()
        
        self.listadoTableView.target = self
        self.listadoTableView.doubleAction = #selector(MFViewController.tableViewDoubleClick(_:))
        
        self.listadoTableView.reloadData()
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = self.colorB
    }
    
    func barcasDia(_ respuesta : [String : AnyObject]) {
        for (k,v) in respuesta {
            if k as String == "contenido" {
               self.reservas = v as! [Int]
            }
        }
    }
    
    func viajeInsertado(_ respuesta : [String : AnyObject]) {
       // print(respuesta)
        for (k,v) in respuesta {
            
            if let _ = v as? Int {
            
                if k as String == "error" && v as! Int == 0 {
                    webService.LBlistado(self.diaHoy.dia, mesI: self.diaHoy.mes, anyoI: self.diaHoy.año, diaF: self.diaHoy.dia, mesF: self.diaHoy.mes, anyoF: self.diaHoy.año)
                    webService.LBestadisticas(self.diaHoy.dia, mesI: self.diaHoy.mes, anyoI: self.diaHoy.año, diaF: self.diaHoy.dia, mesF: self.diaHoy.mes, anyoF: self.diaHoy.año)
                
                    self.rellenarViaje(respuesta)
                    self.imprimirViaje()
                    webServiceReservas.LBnumeroReserva(self.tipoReserva)
                
                } else if k as String == "error" && v as! String == "no hay conexión" {
                    _ = self.alerta("SIN CONEXIÓN", descripcion: "En estos momentos no hay conexión a internet. Avisa al Chus a ver si puede solucionarlo", tipo: "Información")
                } else if k as String == "error" && v as! Int == 1 {
                    _ = self.alerta("SERVIDOR CAÍDO", descripcion: "Hay un problema en el servidor. Avisa al Chus para que intente solucionarlo", tipo: "Información")
                }
            
            } else {
                if k as String == "error" && v as! String == "no hay conexión" {
                    _ = self.alerta("SIN CONEXIÓN", descripcion: "En estos momentos no hay conexión a internet. Avisa al Chus a ver si puede solucionarlo", tipo: "Información")
                    } else if k as String == "error" && v as! Int == 1 {
                    _ = self.alerta("SERVIDOR CAÍDO", descripcion: "Hay un problema en el servidor. Avisa al Chus para que intente solucionarlo", tipo: "Información")
                    }

            }
        }
    }
    
    func obtenerNumeroReserva(_ respuesta : [String : AnyObject]) {
// AQUI DE MOMENTO NO HAY QUE HACER NADA.
        self.reservas = respuesta["reservas"] as! [Int]
    }

    func listadoSalidas(_ respuesta : [String : AnyObject]) {
        var registro : [String : AnyObject] = [:]
        self.listadoSalidas = []
        for (k,v) in respuesta {
           // print ("k : \(k)")
            //print ("v : \(v)")
            if k != "error" {
                registro["numero"] = v["numero"] as! Int as AnyObject?
                if v["tipo"] as! Int == BARKITO {
                    registro["tipo"] = "Barkito" as AnyObject?
                } else if v["tipo"] as! Int == BARCA {
                    registro["tipo"]  = "Barca" as AnyObject?
                } else if v["tipo"] as! Int == GOLD {
                    registro["tipo"] = "Gold" as AnyObject?
                }
                registro["tipo"] = v["tipo"] as! Int as AnyObject?
                registro["base"] = v["base"] as! String as AnyObject?
                registro["hora"] = v["hora_reserva"] as! String as AnyObject?
                
                self.listadoSalidas.append(registro)
            }
        }
        
        self.listadoSalidas.sort { (primero : [String : AnyObject], segundo : [String : AnyObject]) -> Bool in
            return segundo["numero"] as! Int > primero["numero"] as! Int
        }

        self.listadoSalidasNSTableView.reloadData()
    }
    
    func listadoLB(_ respuesta : [String : AnyObject]) {
        var registro : [String : AnyObject] = [:]
        self.listadoViajes = []
        for (k,v) in respuesta {
            
            if k != "error" && k != "numero_tickets" {
                registro["numero"] = v["numero"] as! Int as AnyObject?
                if v["barca"] as! Int == BARKITO {
                    registro["barca"] = "Barkito" as AnyObject?
                } else if v["barca"] as! Int == BARCA {
                    registro["barca"] = "Barca" as AnyObject?
                } else if v["barca"] as! Int == GOLD {
                    registro["barca"] = "Gold" as AnyObject?
                }

                if v["punto_venta"] as! Int == 1 {
                    registro["punto_venta"] = "MarinaFerry" as AnyObject?
                } else if v["punto_venta"] as! Int == 5 {
                    registro["punto_venta"] = "iPad Marina" as AnyObject?
                } else if v["punto_venta"] as! Int == 2 {
                    registro["punto_venta"] = "iPad LosBarkitos" as AnyObject?
                }
                
                if v["blanco"] as! Int == 1 {
                    registro["blanco"] = true as AnyObject?
                } else {
                    registro["blanco"] = false as AnyObject?
                }
                
                let formato = DateFormatter()
                formato.dateFormat = "dd-MM-yy HH:mm:ss"
                let fec = formato.date(from: v["fecha"] as! String)
                registro["fecha"] = formato.string(from: fec!) as AnyObject?
                
                registro["precio"] = v["precio"] as! Float as AnyObject?
                
                self.listadoViajes.append(registro)
                
                // INserción en la lista para impresión 
                let v : Viaje = Viaje()
                
                v.numero = registro["numero"] as! Int
                v.barca = registro["barca"] as! String
                v.fecha = registro["fecha"] as! String
                v.precio = registro["precio"] as! Float
                v.punto = registro["punto_venta"] as! String
                v.blanco = registro["blanco"] as! Bool
                
                viajes.append(v)
                
            }
        }
        self.listadoViajes.sort { (primero : [String : AnyObject], segundo : [String : AnyObject]) -> Bool in
            return segundo["numero"] as! Int > primero["numero"] as! Int
        }
        self.listadoTableView.reloadData()
    }
    
    
    func estadisticas(_ respuesta : [String : AnyObject]) {
        // print("respuesta del servidor : media = \(respuesta)")
        for (k,v) in respuesta {
            if k as String == "error" && v as! Int == 1 { // Error en el servidor
                print("EROR")
            } else if k as String == "media" {
                //  print("Media : " + String(Float(v as! NSNumber)))
                self.media.stringValue = String(describing: v)
            } else if k as String == "euros" {
                //  print("Euros : " + String(Float(v as! NSNumber)))
                self.total.stringValue = String(describing: v)
            } else if k as String == "total_tickets" {
                //  print("Tickets : " + String(Int(v as! NSNumber)))
                self.numTickets.stringValue = String(describing: v)
                
            }
            let formato : DateFormatter = DateFormatter()
            formato.dateFormat = "dd / MM / yyyy"
            self.fecha.stringValue = formato.string(from: self.inicioNSDatePicker.dateValue)
            //self.numeroTickets = Int(v)
        }
    }
    
    func estadisticasTotales(_ respuesta: [String : AnyObject]) {
       // print(respuesta)
        for (k,v) in respuesta {
            if k as String == "error" && v as! Int == 1 { // Error en el servidor
                print("ERROR")
            } else if k as String == "total_tickets" {
                self.numTicketsTotal = v as? Int
            } else if k as String == "euros" {
                self.totalTotal = v as? Float
                
            }
            self.fecha.stringValue = self.inicioNSDatePicker.stringValue
            //self.numeroTickets = Int(v)
        }

    }
    
    
    func imprimirResumen() {
        // Impresion de un ticket resumen del dia
        let t : ticketImpreso = ticketImpreso()
        t.print(self.resumenNSBox as NSView)
    }

    
    // MARK - TableView

    func numberOfRows(in tableView: NSTableView) -> Int {
        
        if tableView.tag == 0 {
            return self.listadoViajes.count
        } else {
            return self.listadoSalidas.count
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
       
        if tableView.tag == 0 { // tableView de las ventas
            var text : String = ""
            var celdaIdentificador : String = ""
            // Item contiene el registro a meter en la Tableview
            let item = self.listadoViajes[row]
            if tableColumn == tableView.tableColumns[0] { // Número
                text = String(item["numero"]! as! Int)
                celdaIdentificador = "numeroCellId"
            } else if tableColumn == tableView.tableColumns[1] { // punto venta
                text = String(item["barca"]! as! String)
                celdaIdentificador = "tipoCellId"
            } else if tableColumn == tableView.tableColumns[2] { // hora
                text = String(item["fecha"]! as! String)
                text = text.substring(with: (text.index(text.endIndex, offsetBy: -8) ..< text.endIndex))
                celdaIdentificador = "horaCellId"
            } else if tableColumn == tableView.tableColumns[3] { // punto venta
                text = String(item["punto_venta"] as! String)
                celdaIdentificador = "puntoVentaCellId"
            } else if tableColumn == tableView.tableColumns[4] { // precio
                text = formato.string(from: item["precio"] as! NSNumber)!
                celdaIdentificador = "precioCellId"
            }
        
            if let celda = tableView.make(withIdentifier: celdaIdentificador, owner: nil)   as? NSTableCellView {
                
                celda.textField?.stringValue = text
                return celda
         
            }
            
        } else { // table view de las Salidas que faltan
            var text : String = ""
            var celdaIdentificador : String = ""
            // item = registro a meter en el tableview
            let item = self.listadoSalidas[row]
            if tableColumn == tableView.tableColumns[0] { // Número
                text = String(item["numero"] as! Int)
                celdaIdentificador = "numeroSalidaCellId"
            } else if tableColumn == tableView.tableColumns[1] { // punto venta
                text = String(item["base"] as! String)
                celdaIdentificador = "puntoVentaSalidaCellId"
            } else if tableColumn == tableView.tableColumns[2] { // hora
                text = String(item["hora"] as! String)
                celdaIdentificador = "horaSalidaCellId"
            }
            if let celda = tableView.make(withIdentifier: celdaIdentificador, owner: nil) as? NSTableCellView {
                
                celda.textField?.stringValue = text
                return celda
            }
            
        }
        return nil
    }
/*
    func montarBlanco() {
        
        for v in self.listadoViajes {
            if v["blanco"] as! Bool == true {
                self.listadoViajesB.append(v)
            }
        }
        for v in viajes {
            if v.blanco  == true {
                viajesB.append(v)
            }
        }
    }*/
    
    func buscarFechaHoy() -> (Int, Int, Int) {
        let formato = DateFormatter()
        let fechaHoy = Date()
        formato.dateFormat = "dd"
        let dia = formato.string(from: fechaHoy)
        formato.dateFormat = "MM"
        let mes = formato.string(from: fechaHoy)
        formato.dateFormat = "yy"
        let año = formato.string(from: fechaHoy)
        
        return (Int(dia)!, Int(mes)!, Int(año)!)
    }
    
    func rellenarViaje(_ datos : [String : AnyObject]) {
       // print(datos)
        for (k,v) in datos {
            switch k {
                case "numero"       : viaje.numero = v as! Int
                case "precio"       : viaje.precio = v as! Float
                case "fecha"        : viaje.fecha  = v as! String
                case "blanco"       : viaje.blanco = true
                case "punto"        : viaje.puntoVenta = 1
                                      viaje.punto = "MarinaFerry"
                case "tipo"         : viaje.tipoBarca = v as! Int
                case "barca"        : viaje.barca = v as! String
            default : break
            }
        }
        
        self.numeroTicketNSTextField.stringValue = String(viaje.numero)
        self.totalEurosTicketNSTextField.stringValue = String(viaje.precio)
        self.ivaTicketNSTextField.stringValue = String(viaje.precio - viaje.precio / 1.21)
        self.baseTicketNSTextField.stringValue = String(viaje.precio / 1.21)
        self.descripcionTicketNSTextField.stringValue = "Viaje en LosBarkitos con \(viaje.barca)"
        self.fechaTicketNSTextField.stringValue = String(viaje.fecha)
        self.numeroReserva = self.reservas[viaje.tipoBarca - 1]
        self.reservaTicketNSTextField.stringValue = String(self.numeroReserva)
        
        // Se aumenta la reserva segun el tipo de barca
       ///////////////////////// webService.LBincrementarReserva(tipo: viaje.tipoBarca)
    }
    
    func imprimirViaje() {
        
        // Impresion del viaje
        let t : ticketImpreso = ticketImpreso()
        t.print(self.viajeNSView)
    }
    
    func reservaIncrementada(_ datos : [String : AnyObject]) {
        
        for (k,v) in datos {
            if k == "contenido" {
                reservas = v as! [Int]
            }
        }
        
    }
    
    func cierre(_ datos: [String : String]) {
        
        if datos["mensaje"] == "ok" {
            _ = self.alerta("DATOS RESTAURADOS", descripcion: "Las reservas se han puesto a 0", tipo: "Información")
        } else {
            _ = self.alerta("PROBLEMAS CON CIERRE", descripcion: "Ha habido un problema (\(datos["mensaje"])) con el cierre. Inténtalo más adelante", tipo: "Información")
        }
        
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueImprimirListadoBarkitos" {
            let VC = segue.destinationController as! imprimirListadoLBViewController
            VC.representedObject = self.listadoViajes.count

            let formato : DateFormatter = DateFormatter()
            formato.dateFormat = "dd / MM / yyyy"
            if self.inicioNSDatePicker.stringValue  == self.finalNSDatePicker.stringValue {
                VC.fecha = formato.string(from: self.inicioNSDatePicker.dateValue)
            } else {
                VC.fecha = formato.string(from: self.inicioNSDatePicker.dateValue) + " - " + formato.string(from: self.finalNSDatePicker.dateValue)
            }
            
            VC.listadoTickets = self.listadoViajes
            VC.total = self.totalTotal!
            VC.numTickets = self.numTicketsTotal!
        } else if segue.identifier == "segueMensual_LB" {
            let VC = segue.destinationController as! mensualListadoLBViewController
            VC.numRegistros = self.listadoMensual.count
            VC.listado = self.listadoMensual
        } else if segue.identifier == "segueReserva" {
            let VC = segue.destinationController as! Reserva
             self.tipoReserva = (sender! as AnyObject).tag
            VC.tipo = self.tipoReserva
        }
    }

    
    func alerta(_ titulo : String, descripcion : String, tipo : String) -> Bool {
        
        let alerta : NSAlert = NSAlert()
        alerta.messageText = titulo
        alerta.informativeText = descripcion
        if tipo == "Información" {
            alerta.alertStyle = NSAlertStyle.informational
        } else if tipo == "Warning" {
            alerta.alertStyle = NSAlertStyle.warning
        }
        alerta.addButton(withTitle: "Ok?")
        _ = alerta.runModal()
        
        return true
        
    }

    
    
}
