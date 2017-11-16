//
//  Reserva.swift
//  tpv
//
//  Created by Jesus Valladolid Rebollar on 21/4/16.
//  Copyright © 2016 LosBarkitos. All rights reserved.
//

import Cocoa

class Reserva: NSViewController, datosBDD_R {

    var tipo : Int = 0
    var reservas : [Int] = [0,0,0]
    
    let BARKITO   = 1
    let BARCA     = 2
    let GOLD      = 3
    
    let webService : webServiceCallApiR = webServiceCallApiR()
    
    @IBOutlet weak var numeroReserva: NSTextField!
    @IBOutlet weak var tipoBarca: NSTextField!
    @IBOutlet weak var imprimirVista: NSView!
    @IBOutlet weak var horaReserva: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webService.delegate = self
        webService.LBnumeroReserva(tipo)
        
        // Do view setup here.
    }
    
    func obtenerNumeroReserva(_ respuesta : [String : AnyObject]) {
        var tipo : String = ""
        var HR : String = ""
        var HP : String = ""
        
        self.reservas = [0,0,0,0]
        
        for (k,v) in respuesta {
            if k as String == "error" && v as! String != "no" { // error en el servidor
                //print("ERROR")
                
            } else if k as String == "reservas" {
                self.reservas = v as! [Int]
            } else if k as String == "hora reserva" {
                HR = v as! String
            } else if k as String == "hora prevista" {
                HP = v as! String
            } else if k == "exito"  {
                tipo = v as! String
            }
        }

        if self.reservas[0] > 0 {
            tipo = "BARKITO"
            self.numeroReserva.stringValue = String(self.reservas[0])
        } else if self.reservas[1] > 0 {
            tipo = "BARCA"
            self.numeroReserva.stringValue = String(self.reservas[1])
        } else {
            tipo = "GOLD"
            self.numeroReserva.stringValue = String(self.reservas[2])
        }
        self.horaReserva.stringValue = HR
        self.tipoBarca.stringValue = tipo
        imprimirReserva()
        self.dismiss(self)
    }
    
    func imprimirReserva() {
        
        let t : ticketImpreso = ticketImpreso()
        t.print(self.imprimirVista as NSView)
    }
    
}
