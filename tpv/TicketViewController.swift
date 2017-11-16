//
//  TicketViewController.swift
//  tpv
//
//  Created by Jesus Valladolid Rebollar on 22/4/16.
//  Copyright © 2016 LosBarkitos. All rights reserved.
//

import Cocoa

class TicketViewController: NSViewController {
    @IBOutlet weak var fechaTicketNSTextField: NSTextField!
    @IBOutlet weak var numeroTicketNSTextField: NSTextField!
    @IBOutlet weak var descripcionTicketNSTextField: NSTextField!
    @IBOutlet weak var baseTicketNSTextField: NSTextField!
    @IBOutlet weak var ivaTicketNSTextField: NSTextField!
    @IBOutlet weak var totalEurosTicketNSTextField: NSTextField!
    @IBOutlet weak var grupoParticularTicketNSTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
