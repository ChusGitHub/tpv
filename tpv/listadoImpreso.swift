//
//  listadoImpreso.swift
//  tpv
//
//  Created by chus on 16/3/16.
//  Copyright © 2016 LosBarkitos. All rights reserved.
//

import Cocoa

class listadoImpreso: NSView {

    let printInfo : NSPrintInfo = NSPrintInfo()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func print(_ sender: Any?) {
        
        self.printInfo.printer = NSPrinter(name: "KONICA MINOLTA")!
        self.printInfo.leftMargin  = 0.0
        self.printInfo.rightMargin = 0.0
        self.printInfo.topMargin = 0.0
        self.printInfo.bottomMargin = 0.0
        self.printInfo.isHorizontallyCentered = true
        self.printInfo.isVerticallyCentered = true
        self.printInfo.jobDisposition = NSPrintSpoolJob
        self.printInfo.paperSize = NSSize(width: 595, height: 841)
        let pag : NSPrintingPaginationMode = NSPrintingPaginationMode.fitPagination
        self.printInfo.verticalPagination = pag
    
        let op = NSPrintOperation.init(view: sender as! NSView, printInfo: self.printInfo)
        //op.showsPrintPanel = true
        op.showsPrintPanel = false
        op.run()
    }
}
