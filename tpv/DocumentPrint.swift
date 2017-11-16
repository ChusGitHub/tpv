//
//  DocumentPrint.swift
//  tpv
//
//  Created by LosBarkitos on 19/1/16.
//  Copyright © 2016 LosBarkitos. All rights reserved.
//

import Cocoa

class DocumentPrint: NSDocument, NSWindowDelegate {

    var tableViewListado : NSTableView!
    
    var tickets : [Ticket] = []
    
    override init() {
        super.init()
    }
    
    override var windowNibName: String? {
        // Override returning the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
        return "DocumentPrint"
    }

    override func windowControllerDidLoadNib(_ aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }
    
    override func data(ofType typeName: String) throws -> Data {
        self.tableViewListado.window!.endEditing(for: nil)
        return NSKeyedArchiver.archivedData(withRootObject: tickets)
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        self.tickets = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Ticket]
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }
    

    
    override func printOperation(withSettings printSettings: [String : Any]) throws -> NSPrintOperation {
        let ticketsPrintigView : listadoPrintingView = listadoPrintingView(tickets: tickets)
        let printInfo : NSPrintInfo = self.printInfo
        let printOperation : NSPrintOperation = NSPrintOperation(view: ticketsPrintigView, printInfo: printInfo)
        
        return printOperation
    }
}
