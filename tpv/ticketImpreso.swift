//
//  ticketImpreso.swift
//  tpv
//  Jesús Valladolid Rebollar
//  Created by Jesus Valladolid Rebollar on 1/2/16.
//  Copyright © 2016 LosBarkitos. All rights reserved.
//

import Cocoa

class ticketImpreso: NSView {
    
    //let nombrePrinter : NSPrinter = NSPrinter(name: "BILOXON SRP-350")!
    let printInfo : NSPrintInfo = NSPrintInfo()

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        
    }
    
    override func print(_ sender: Any?) {
       // self.printInfo.printer = NSPrinter(name: "TSP700")!
        self.printInfo.leftMargin  = 0.0
        self.printInfo.rightMargin = 0.0
        self.printInfo.topMargin = 0.0
        self.printInfo.isHorizontallyCentered = true
        self.printInfo.isVerticallyCentered = false
        self.printInfo.jobDisposition = NSPrintSpoolJob
        self.printInfo.paperSize = NSSize(width: 190, height: 480)
        
        let op = NSPrintOperation.init(view: sender as! NSView, printInfo: self.printInfo)
        //op.showsPrintPanel = true
        op.showsPrintPanel = false
        op.run()
    }
    
}
