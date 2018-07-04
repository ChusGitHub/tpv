//
//  MFViewController.swift
//  tpv
//  Jesús Valladolid Rebollar
//  Created by LosBarkitos on 22/12/15.
//  Copyright © 2015 LosBarkitos. All rights reserved.

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


public var tickets : [Ticket] = []
public var numeroTic : Int = 0

class MFViewController: NSViewController, datosBDD, NSTableViewDataSource, NSTableViewDelegate {
    
    var webService : webServiceCallAPI = webServiceCallAPI()
    //var listadoTickets = [[String : AnyObject]]?()
    var listadoTickets = [[String : AnyObject]]()
    var listadoMensual = [[String : AnyObject]]()
    var diaHoy = (dia : 1, mes : 1, año : 1)
    
    var tic : Ticket = Ticket()
    
    var contadorParticular : Int = 0 {
        didSet {
            self.contParticularesNsTextField.stringValue = String(contadorParticular)
          
        }
    }
    
    var contadorGrupo : Int = 0 {
        didSet {
            self.contGruposNsTextField.stringValue = String(contadorGrupo)
            
        }
    }
    
    let formato : NumberFormatter = NumberFormatter()
    
    let printInfo : NSPrintInfo = NSPrintInfo.shared()
    
    
    @IBOutlet weak var individualButton: NSButton!
    @IBOutlet weak var gruposButton: NSButton!
    @IBOutlet weak var barkitoButton: NSButton!
    @IBOutlet weak var precioTicketBarkito: NSTextField!
    @IBOutlet weak var ticketsBarkitosView: NSView!
    
    @IBOutlet weak var precio_6_Individual: NSButton!
    @IBOutlet weak var precio_8_Individual: NSButton!
    @IBOutlet weak var precio_9_Individual: NSButton!
    @IBOutlet weak var precio_10_Individual: NSButton!
    @IBOutlet weak var precio_12_Individual: NSButton!
    @IBOutlet weak var precio_750_Grupos: NSButton!
    @IBOutlet weak var precio_770_Grupos: NSButton!
    @IBOutlet weak var precio_8_Grupos: NSButton!
    @IBOutlet weak var precio_850_Grupos: NSButton!
    @IBOutlet weak var precio_9_Grupos: NSButtonCell!
    @IBOutlet weak var precio_10_Grupos: NSButtonCell!
    @IBOutlet weak var precio_11_Grupos: NSButton!
    @IBOutlet weak var precio_12_Grupos: NSButton!
    @IBOutlet weak var precio_raro: NSButton!
    
    @IBOutlet weak var precioGruposView: NSView!
    @IBOutlet weak var precioIndividualView: NSView!

    @IBOutlet weak var listadoView: NSView!
    
    @IBOutlet weak var listarNSButton: NSButton!
    @IBOutlet weak var listadoTableView: NSTableView!
    
    
    @IBOutlet weak var boxResumenListado: NSBox!
    @IBOutlet weak var totalTicketsNSTextField: NSTextField!
    @IBOutlet weak var totalEurosNSTextField: NSTextField!
    @IBOutlet weak var mediaNSTextField: NSTextField!
  
    @IBOutlet weak var ticketNSView: NSView!
    
    @IBOutlet weak var inicioNSDatePicker: NSDatePicker!
    @IBOutlet weak var finalNSDatePicker: NSDatePicker!
    
    @IBOutlet weak var contParticularesNsTextField: NSTextField!
    
    @IBOutlet weak var contGruposNsTextField: NSTextField!
    
    // Campos y vista de la entrada masiva de tickets para grupos
    @IBOutlet weak var ticketsMasivosNSView: NSView!
    @IBOutlet weak var numTicketsMasivos: NSTextField!
    
    /// Campos del Ticket a imprimir
    @IBOutlet weak var fechaTicketNSTextField: NSTextField!
    @IBOutlet weak var numeroTicketNSTextField: NSTextField!
    @IBOutlet weak var descripcionTicketNSTextField: NSTextField!
    @IBOutlet weak var baseTicketNSTextField: NSTextField!
    @IBOutlet weak var ivaTicketNSTextField: NSTextField!
    @IBOutlet weak var totalEurosTicketNSTextField: NSTextField!
    @IBOutlet weak var grupoParticularTicketNSTextField: NSTextField!
    
    @IBOutlet weak var listarNSPushButton: NSButton!
    
    
    
    // Botones control ticket
    @IBOutlet weak var botonesTicketNSview: NSView!
    @IBOutlet weak var imprimirTicketNSButton: NSButton!
    @IBOutlet weak var modificarTicketNSButton: NSButton!
    @IBOutlet weak var borrarTicketNSButton: NSButton!
    @IBOutlet weak var salirTicketNSButton: NSButton!
    
    ///////////////////////////////////
    
    // BOTONES DE LA VISTA PARA CAMBIAR EL PRECIO
    @IBOutlet weak var cambioPrecioNSView: NSView!
    @IBOutlet weak var nuevoPrecioNSTextField: NSTextField!
    @IBOutlet weak var okNuevoPrecioNSButton: NSButton!
    ///////////////////////////////////////////////////////////
    
    
    @IBAction  func listarNSButton(_ sender : NSButton) {
        
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
        
        
        webService.MFlistado(Int(diaI)!, mesI: Int(mesI)!, anyoI: Int(añoI)!, diaF: Int(diaF)!, mesF: Int(mesF)!, anyoF: Int(añoF)!)
        
        webService.MFestadisticas(Int(diaI)!, mesI: Int(mesI)!, anyoI: Int(añoI)!, diaF: Int(diaF)!, mesF: Int(mesF)!, anyoF: Int(añoF)!)
    }
    
    @IBAction func recuperar(_ sender: NSButtonCell) {
        webService.MFrecuperar_ticket(14)
        /*        let numero : Int = 14
        let url : String = "https://losbarkitos.herokuapp.com/MFrecuperar_ticket/" + String(numero)
        webService.MFrequestBDD(url)
        */
    }
    
    @IBAction func eurosPush(_ sender: NSButton) {
        webService.MFeuros(1, mesI: 1, anyoI: 15, diaF: 31, mesF: 12, anyoF: 15)
    }
    @IBAction func mediaPush(_ sender: NSButton) {
        webService.MFmedia(1, mesI: 1, anyoI: 15, diaF: 31, mesF: 12, anyoF: 15)
    }
    

    @IBAction func individualPushButton(_ sender: NSButtonCell) {
        
        if sender.state == NSOnState {
            self.precioIndividualView.isHidden = false
            self.precioGruposView.isHidden = true
            self.gruposButton.state = NSOffState
        } else {
            self.precioIndividualView.isHidden = true
            self.precioGruposView.isHidden = true
        }
        
    }
    @IBAction func gruposPushButton(_ sender: NSButtonCell) {
        
        if sender.state == NSOnState {
            self.precioGruposView.isHidden = false
            self.precioIndividualView.isHidden = true
            self.individualButton.state = NSOffState
            self.ticketsMasivosNSView.alphaValue = 1
        } else {
            self.precioGruposView.isHidden = true
            self.precioIndividualView.isHidden = true
            self.ticketsMasivosNSView.alphaValue = 0
        }
    }
    
    @IBOutlet weak var barkitoPushButton: NSButton!
    @IBAction func barkitoPushButton(_ sender: NSButton) {
        if self.ticketsBarkitosView.alphaValue == 0 {
            self.ticketsBarkitosView.alphaValue = 1
        } else {
            self.ticketsBarkitosView.alphaValue = 0
        }
        
    }
    
    @IBAction func okTicketBarkitoPushButton(_ sender: NSButton) {
        if self.precioTicketBarkito.stringValue != "" && self.precioTicketBarkito.stringValue != "0" {
            webService.MFinsertar_ticket(Float(self.precioTicketBarkito.stringValue)!, part: 2)
        }
        
        
    }
    @IBAction func precioIndividualPushButton(_ sender: NSButton) {
        if let precio : Float = Float(sender.title) {
            webService.MFinsertar_ticket(precio, part: 1) // Si parametro = 1 es particular
            self.contadorParticular += 1
        }
    }
    
    
    @IBAction func precioGruposPushButton(_ sender: NSButton) {
        
        if Int(self.numTicketsMasivos.stringValue) == 1 {
            if let precio : Float = Float(sender.title) {
               
                webService.MFinsertar_ticket(precio, part: 0) // Si parametro = 0 es grupo
                self.contadorGrupo += 1
            }
        } else if Int(self.numTicketsMasivos.stringValue) > 1 {
            let num = Int(self.numTicketsMasivos.stringValue)!
            let precio : Float? = Float(sender.title)
            webService.MFinsertar_ticket_masivo(precio!, cantidad: num)
            self.contadorGrupo += num
       
        }
        self.numTicketsMasivos.stringValue = "1"
    }
    
    @IBAction func reImprimirTicketNSButton(_ sender: NSButton) {
        
        self.imprimirTicket()
        
    }
    
    @IBAction func modificarTicket(_ sender: NSButton) {
        // primero se borra el ticket y luego se inserta el nuevo
        webService.MFborrar_ticket(self.tic.numero, modo: "MODIFICAR")
    }
    
    @IBAction func borrarTicketNSButton(_ sender: NSButton) {
        webService.MFborrar_ticket(self.tic.numero, modo: "BORRAR")
        self.listarNSButton(self.listarNSButton)
    }
    
    
    @IBAction func salirTicketNSButton(_ sender: NSButton) {
   
        self.ticketNSView.alphaValue = 0
        self.botonesTicketNSview.alphaValue = 0
        
    }
    
    @IBAction func anadirNuevoPrecio(_ sender : AnyObject) {

        if self.precioIndividualView.isHidden == false || self.precioGruposView.isHidden == false {
            self.cambioPrecioNSView.isHidden = false
        }
    }
    
    @IBAction func imprimirMensual(_ sender : AnyObject) {
        
                
    }
    
    
    @IBAction func okNuevoPrecioPushButton(_ sender: NSButton) {
        
        guard let precio = Int(self.nuevoPrecioNSTextField.stringValue) else {
            self.cambioPrecioNSView.isHidden = true
            return
        }
        if self.precioIndividualView.isHidden ==  false {
            self.precio_12_Individual.title = String(precio)
        } else {
            self.precio_raro.title = String(precio)
        }
        self.cambioPrecioNSView.isHidden = true
    }
    @IBAction func imprimirListadoPushButton(_ sender: NSButton) {
        
       // let size : NSSize = NSSize(width: self.listadoView.bounds.width , height: 980)
        //self.listadoView.setFrameSize(size)
        
    }
    
    @IBAction func imprimirResumenPushButton(_ sender: NSButton) {
        self.boxResumenListado.isHidden = false
        self.imprimirResumen()
        self.boxResumenListado.isHidden = true
    }
    
    @IBAction func poner0particularPushButton(_ sender: NSButton) {
        
        self.contadorParticular = 0
        
    }
    @IBAction func poner0grupoPushButton(_ sender: NSButton) {
        
        self.contadorGrupo = 0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formato.maximumFractionDigits = 2
        formato.minimumFractionDigits = 2
        formato.roundingMode = .halfEven
        
        self.contGruposNsTextField.stringValue = "0"
        self.contParticularesNsTextField.stringValue = "0"
        
        self.diaHoy = self.buscarFechaHoy()
        
        webService.delegate = self
        
        self.individualButton.setButtonType(NSButtonType.pushOnPushOff)
        self.gruposButton.setButtonType(NSButtonType.pushOnPushOff)
        
        self.precioIndividualView.isHidden = true
        self.precioGruposView.isHidden = true
        self.ticketsBarkitosView.alphaValue = 0
        
        self.precioIndividualView.setFrameOrigin(NSPoint(x : 20, y : 325))
        self.precioGruposView.setFrameOrigin(NSPoint(x : 20, y : 325))
        
        webService.MFlistado(self.diaHoy.dia, mesI: self.diaHoy.mes, anyoI: self.diaHoy.año,
            diaF: self.diaHoy.dia, mesF: self.diaHoy.mes, anyoF: self.diaHoy.año)
        
        webService.MFestadisticas(self.diaHoy.dia, mesI:self.diaHoy.mes, anyoI: self.diaHoy.año, diaF: self.diaHoy.dia, mesF: self.diaHoy.mes, anyoF: self.diaHoy.año)

        self.inicioNSDatePicker.dateValue = Date()
        self.finalNSDatePicker.dateValue = Date()
        
        self.listadoTableView.delegate = self
        self.listadoTableView.dataSource = self
        
        // Esto hace que los eventos sean recogidos en esta clase
        // Y envia la accion de "doble click" al nsVIew determinado
        self.listadoTableView.target = self
        self.listadoTableView.doubleAction = #selector(MFViewController.tableViewDoubleClick(_:))
        
        self.listadoTableView.reloadData()
        
        self.cambioPrecioNSView.isHidden = true
        self.boxResumenListado.isHidden = true
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    //  METODOS DELEGADOS DE datosBDD
    func ticketInsertado(_ respuesta : [String : AnyObject]) {
        
        for (k,v) in respuesta {
            if k as String == "error" && v as! Int == 1 {
                print("ERROR EN EL SERVIDOR")
            } else if k as String == "error" && v as! Int == 0 {
                
                webService.MFlistado(self.diaHoy.dia, mesI: self.diaHoy.mes, anyoI: self.diaHoy.año,
                                     diaF: self.diaHoy.dia, mesF: self.diaHoy.mes, anyoF: self.diaHoy.año)
                webService.MFestadisticas(self.diaHoy.dia, mesI:self.diaHoy.mes, anyoI: self.diaHoy.año, diaF: self.diaHoy.dia, mesF: self.diaHoy.mes, anyoF: self.diaHoy.año)
                
                numeroTic += 1
                
                self.rellenarTicket(respuesta)
                self.imprimirTicket()
            }
        }
    }
    
    func ticketsInsertadosMasivos(_ respuesta : [String : AnyObject]) {
        var cantidad : Int = 0
        for (k,v) in respuesta {
            print(v)
            if k as String == "error" && v as! Int == 1 {
                self.alerta("ERROR SERVIDOR", descripcion: "El ticket no ha sido insertado", tipo: "Warning")
            } else {
                if k as String == "cantidad" {
                   // print(v as! Int)
                    cantidad = v as! Int
                }
                if k as String == "numero" {
                        numeroTic = v as! Int
                    
                }
            }
        }
        
        self.rellenarTicketsMasivos(respuesta)
      
        for c in ((0 + 1)...cantidad).reversed() {
            self.numeroTicketNSTextField.stringValue = String(numeroTic - c + 1)
            self.imprimirTicket()
        }

        self.listarNSButton(self.listarNSButton)
    }
    
    func ticketRecuperado(_ respuesta : [String : AnyObject]) {
       // print("respuesta del servidor : \(respuesta)")
        for (k,v) in respuesta {
            if k as String == "numero" {
                print("REGISTRO \(v as! String) RECUPERADO CORRECTAMENTE")
            }
        }
    }
    
    func ticketBorrado(_ respuesta: [String : AnyObject], modo : String) {
        
        for (k,v) in respuesta {
            if k as String == "error" && v as! Int == 0 { // No hay error
                self.alerta("TICKET BORRADO", descripcion: "El ticket ha sido borrado correctamente", tipo: "Información")
                self.ticketNSView.alphaValue = 0
                self.botonesTicketNSview.alphaValue = 0
            }
        }
        
        if modo == "MODIFICAR" { // es una modificacion
            self.tic.numero = Int(self.numeroTicketNSTextField.stringValue)!
            self.tic.precio = Float(self.totalEurosTicketNSTextField.stringValue)!
            self.tic.fecha = self.fechaTicketNSTextField.stringValue
            self.tic.punto = self.baseTicketNSTextField.stringValue
            if self.grupoParticularTicketNSTextField.stringValue == "PARTICULAR" {
                self.tic.particular = true
            } else {
                self.tic.particular = false
            }
            webService.MFmodificar_ticket(self.tic.numero, precio: self.tic.precio)
        }
        
        webService.MFlistado(self.diaHoy.dia, mesI: self.diaHoy.mes, anyoI: self.diaHoy.año,
                             diaF: self.diaHoy.dia, mesF: self.diaHoy.mes, anyoF: self.diaHoy.año)


    
    }
    
    func ticketModificado(_ respuesta : [String : AnyObject]) {
        //print("respuesta del servidor : \(respuesta)")
        for (k,v) in respuesta {
            if k as String == "error" && v as! Int == 0 {
                print("REGISTRO MODIFICADO")
            }
        }
    }
    
    func listadoMF(_ respuesta: [String : AnyObject]) {
        var registro : [String : AnyObject] = [:]
        self.listadoTickets = []
       // print("respuesta del servidor : \(respuesta)")
        for (k,v) in respuesta {
      
            if k != "error" && k != "numero_tickets" && k != "numero_grupos" && k != "numero_particulas" {
                registro["numero"] = v["numero"] as! Int as AnyObject?
                if v["punto_venta"] as! Int == 1 {
                    registro["punto_venta"] = "MarinaFerry" as AnyObject?
                } else {
                    registro["punto_venta"] = "iPad" as AnyObject?
                }
                let formato = DateFormatter()
                formato.dateFormat = "dd-MM-yy HH:mm:ss"
                let fec = formato.date(from: v["fecha"] as! String)
                registro["fecha"] = formato.string(from: fec!) as AnyObject?
                //registro["fecha"] = v["fecha"] as! String
                
                registro["precio"] = v["precio"] as! Float as AnyObject?
            
                self.listadoTickets.append(registro)
                
                // Insercion en la lista para impresion
                let t : Ticket = Ticket()
        
                t.numero = registro["numero"] as! Int
                t.fecha  = registro["fecha"] as! String
                t.precio = registro["precio"] as! Float
                t.punto  = registro["punto_venta"] as! String
                
                tickets.append(t)
                
            }
        }
        self.listadoTickets.sort { (primero : [String : AnyObject], segundo : [String : AnyObject]) -> Bool in
            return segundo["numero"] as! Int > primero["numero"] as! Int
        }
        //print("Registro para el tableview \(self.listadoTickets)")
        self.listadoTableView.reloadData()
        
    }
    
    
    func euros(_ respuesta : [String : Float]) {
        //print("respuesta del servidor : total = \(respuesta)")
        for (k,v) in respuesta {
            if k as String == "total" {
               // print("Total Euros : " + String(v))
                self.totalEurosNSTextField.stringValue = String(v)
               // self.total€ = Float(v)
            }
        }
        
    }
    
    
    func media(_ respuesta : [String : Float]) {
       // print("respuesta del servidor : media = \(respuesta)")
        for (k,v) in respuesta {
            if k as String == "media" {
               // print("Media : " + String(v))
                self.mediaNSTextField.stringValue = String(v)
                //self.media€ = Float(v)
            }
        }
        
    }
    
    func numeroTickets(_ respuesta : [String : Int]) {
        //print("respuesta del servidor : media = \(respuesta)")
        for (k,v) in respuesta {
            if k as String == "media" {
              //7  print("Numero Tickets : " + String(v))
                self.mediaNSTextField.stringValue = String(v)
                //self.numeroTickets = Int(v)
            }
        }
        
    }
    
    func estadisticas(_ respuesta : [String : AnyObject]) {
       // print("respuesta del servidor : media = \(respuesta)")
        for (k,v) in respuesta {
            if k as String == "media" {
              //  print("Media : " + String(Float(v as! NSNumber)))
                self.mediaNSTextField.stringValue = String(describing: v)
            } else if k as String == "euros" {
              //  print("Euros : " + String(Float(v as! NSNumber)))
                self.totalEurosNSTextField.stringValue = String(describing: v)
            } else if k as String == "total_tickets" {
              //  print("Tickets : " + String(Int(v as! NSNumber)))
                self.totalTicketsNSTextField.stringValue = String(describing: v)
                
            }
                //self.numeroTickets = Int(v)
        }
    }
        

    

    
    /*    func respuesta(respuesta : [String : AnyObject]) {
    print("respuesta del servidor : \(respuesta)")
    }
    */
    
    // MARK - TableView
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return self.listadoTickets.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text : String = ""
        var celdaIdentificador : String = ""
        // Item contiene el registro a meter en la tableView
        let item = self.listadoTickets[row]
        
        if tableColumn == tableView.tableColumns[0] { // Número
            text = String(item["numero"]! as! Int)
            celdaIdentificador = "numeroCellId"
        } else if tableColumn == tableView.tableColumns[1] { // punto_venta
            text = String(item["punto_venta"]! as! String)
            celdaIdentificador = "puntoVentaCellId"
        } else if tableColumn == tableView.tableColumns[2] { // fecha
            text = String(item["fecha"]! as! String)
            celdaIdentificador = "fechaCellId"
        } else if tableColumn == tableView.tableColumns[3] { // precio
            text = formato.string(from: item["precio"] as! NSNumber)!
            celdaIdentificador = "precioCellId"
        }

        if let celda = tableView.make(withIdentifier: celdaIdentificador, owner: nil) as? NSTableCellView {
            celda.textField?.stringValue = text
            return celda
        }
        return nil
    }
    
    
    func tableViewDoubleClick(_ sender : AnyObject?) {
        
        let fila = sender?.selectedRow!
        var datos = [String : AnyObject]()
        datos["numero"]      = self.listadoTickets[fila!]["numero"]
        datos["punto_venta"] = self.listadoTickets[fila!]["punto_venta"]
        datos["precio"]      = self.listadoTickets[fila!]["precio"]
        datos["fecha"]       = self.listadoTickets[fila!]["fecha"]
        
        rellenarTicket(datos)
        self.ticketNSView.alphaValue = 1
        self.botonesTicketNSview.alphaValue = 1
        self.modificarTicketNSButton.isEnabled = false
        
    //    self.performSegueWithIdentifier("segue_ticket", sender: nil)
        
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////

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
    
    func rellenarTicket(_ datos : [String : AnyObject]) {
        for (k,v) in datos {
            switch k  {
                case "numero"     : tic.numero     = v as! Int
                case "precio"     : tic.precio     = v as! Float
                case "fecha"      : tic.fecha      = v as! String
                case "punto"      : tic.punto      = v as! String
                case "particular" : tic.particular = v as! Bool
            default : break
            }
        }
        self.numeroTicketNSTextField.stringValue  = String(tic.numero)
        self.baseTicketNSTextField.stringValue    = NSString(format: "%.02f", tic.base()) as String
        self.fechaTicketNSTextField.stringValue   = String(tic.fecha)
        self.totalEurosTicketNSTextField.stringValue  = NSString(format: "%.02f", tic.precio) as String
        self.ivaTicketNSTextField.stringValue     = NSString(format: "%.02f", tic.iva()) as String
        
        if tic.particular == true {
            self.grupoParticularTicketNSTextField.stringValue = "PARTICULAR"
            self.descripcionTicketNSTextField.stringValue = "1 ticket adulto particular"
        } else {
            self.descripcionTicketNSTextField.stringValue = "1 ticket adulto grupo"
            self.grupoParticularTicketNSTextField.stringValue = "GRUPO"
        }
    }
    
    func rellenarTicketsMasivos(_ datos : [String : AnyObject]) {
        for (k,v) in datos {
            switch k  {
                case "numero"     : tic.numero      = v as! Int
                case "precio"     : tic.precio      = v as! Float
                case "fecha"      : tic.fecha       = v as! String
                case "punto"      : tic.punto       = v as! String
                case "particular" : tic.particular  = v as! Bool
            default : break
            }
        }
        self.numeroTicketNSTextField.stringValue  = String(tic.numero)
        self.baseTicketNSTextField.stringValue    = NSString(format: "%.02f", tic.base()) as String
        self.fechaTicketNSTextField.stringValue   = String(tic.fecha)
        self.totalEurosTicketNSTextField.stringValue  = NSString(format: "%.02f", tic.precio) as String
        self.ivaTicketNSTextField.stringValue     = NSString(format: "%.02f", tic.iva()) as String
        
        if tic.particular == true {
            self.grupoParticularTicketNSTextField.stringValue = "PARTICULAR"
            self.descripcionTicketNSTextField.stringValue = "1 ticket adulto particular"
        } else {
            self.descripcionTicketNSTextField.stringValue = "1 ticket adulto grupo"
            self.grupoParticularTicketNSTextField.stringValue = "GRUPO"
        }


    }
    
    func imprimirResumen() {
        // Impresion de un ticket resumen del dia
        let t : ticketImpreso = ticketImpreso()
        t.print(self.boxResumenListado as NSView)
    }
    
    func imprimirTicket() {
        
        // Impresion del ticket
        let t : ticketImpreso = ticketImpreso()
        t.print(self.ticketNSView)
    }
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "segueImprimirListadoViewController" {
            let VC = segue.destinationController as! ImprimirListadoViewController
            VC.representedObject = self.listadoTickets.count
            
            let formato : DateFormatter = DateFormatter()
            formato.dateFormat = "dd / MM / yyyy"
            if self.inicioNSDatePicker.stringValue  == self.finalNSDatePicker.stringValue {
                VC.fecha = formato.string(from: self.inicioNSDatePicker.dateValue)
            } else {
                VC.fecha = formato.string(from: self.inicioNSDatePicker.dateValue) + " - " + formato.string(from: self.finalNSDatePicker.dateValue)        }
        
            VC.total = Float(self.totalEurosNSTextField.stringValue)!
        
            VC.numTickets = Int(self.totalTicketsNSTextField.stringValue)!
            VC.listadoTickets = self.listadoTickets
        } else if segue.identifier == "segue_mensual" {
            let VC = segue.destinationController as! mensualListadoViewController
            VC.numRegistros = self.listadoMensual.count
            VC.listado = self.listadoMensual
        } else if segue.identifier == "segue_ticket" {
            let VC = segue.destinationController as! TicketViewController
        
            
            VC.numeroTicketNSTextField.stringValue  = String(tic.numero)
            VC.baseTicketNSTextField.stringValue    = NSString(format: "%.02f", tic.base()) as String
            VC.fechaTicketNSTextField.stringValue   = String(tic.fecha)
            VC.totalEurosTicketNSTextField.stringValue  = NSString(format: "%.02f", tic.precio) as String
            VC.ivaTicketNSTextField.stringValue     = NSString(format: "%.02f", tic.iva()) as String
            VC.grupoParticularTicketNSTextField.stringValue = "GRUPO"
            VC.descripcionTicketNSTextField.stringValue = "1 ticket adulto grupo"

        }
    }
    
    func alerta(_ titulo : String, descripcion : String, tipo : String) {
        
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
        
        
    }
}
