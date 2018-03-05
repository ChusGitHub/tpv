//
//  Tickets.swift
//  tpv
//  Jesús Valladolid Rebollar
//  Created by LosBarkitos on 17/1/16.
//  Copyright © 2016 LosBarkitos. All rights reserved.
//

import Cocoa

open class Ticket: NSObject {
    var idticket : Int = 0
    var numero : Int = 0
    var fecha : String = ""
    var precio : Float = 0.0
    var punto : String = ""
    var particular : Bool = true
    
    func base() -> Float { return Float(precio / 1.21)}
    func iva() -> Float { return Float(precio - base()) }
 
    override init() {
        super.init()
    }
}
