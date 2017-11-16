//
//  datosBDD.swift
//  tpv
//  Jesús Valladolid Rebollar
//  Created by LosBarkitos on 22/12/15.
//  Copyright © 2015 LosBarkitos. All rights reserved.
//
import Alamofire

import Foundation

protocol datosBDD {
    
    // Devuelve el resultado de la insercion de un ticket en MF
    func ticketInsertado(_ : [String : AnyObject])
    // Devuelve el resultado de la insercion masiva de tickets
    func ticketsInsertadosMasivos(_ : [String : AnyObject])
    // Devuelve los datos de un ticket determinado
    func ticketRecuperado(_ : [String : AnyObject])
    // Devuelve el total de Euros en un periodo determinado
    func ticketBorrado(_ : [String :AnyObject], modo : String)
    // Devuelve el resultado de la modificación de un ticket en MF
    func ticketModificado(_ : [String : AnyObject])
    // Devuelve los euros de un periodo determinado
    func euros(_ : [String : Float])
    func media(_: [String : Float]) // Devuelve la media de un periodo determinado
    func numeroTickets (_ : [String : Int])
    func estadisticas(_ : [String : AnyObject])
    // Funcion que devuelva el listado segun las fechas indicadas
    func listadoMF(_ : [String : AnyObject])
       
}

protocol datosBBD2 {
    func listadoMensualMF(_ : [String : AnyObject])

}

protocol datosBDD_LB {
    func estadisticas(_ : [String : AnyObject])
    func estadisticasTotales(_ : [String : AnyObject])
    func listadoLB(_ : [String : AnyObject])
    // Devuelve el resultado de la insercion de un tiquet en LB
    func viajeInsertado(_: [String : AnyObject])
    func barcasDia(_ : [String : AnyObject])
    func reservaIncrementada(_ : [String : AnyObject])
    func cierre(_ : [String : String])
}

protocol datosBDD_LB2 {
    func listadoMensualLB(_ : [String : AnyObject])
}

protocol datosBDD_R {
    func obtenerNumeroReserva(_ : [String : AnyObject])
}

protocol datosBDD_LS {
    func listadoSalidas(_ : [String : AnyObject])
}

class webServiceCallApi2 : NSObject {
    var delegate : datosBBD2?
    
    
    func MFlistadoMensual(_ mes : Int, ano : Int) {
        let url : String = "http://www.marinaferry.info/MFlistado_mensual/" + String(mes) + "/" + String(ano)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.listadoMensualMF(diccionario)
                }
        }
    }

}

class webServiceCallApiLB2 : NSObject {
    var delegate : datosBDD_LB2?
    
    
    func LBlistadoMensualB(_ mes : Int, ano : Int) {
        let url : String = "http://www.marinaferry.info/LBlistado_mensualB/" + String(mes) + "/" + String(ano)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.listadoMensualLB(diccionario)
                }
        }
    }
    
    func LBlistadoMensual(_ mes : Int, ano : Int) {
        let url : String = "http://www.marinaferry.info/LBlistado_mensual/" + String(mes) + "/" + String(ano)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.listadoMensualLB(diccionario)
                }
        }
    }

}

class webServiceCallAPI: NSObject {
    var delegate : datosBDD?
    

    // url(r'^MFinsertar_ticket/(\d{1,})/$', MFinsertarTicket),
    // data = {'error' : 1, 'tipo error' : 'Error en la grabacion del ticket'}
    func MFinsertar_ticket(_ precio : Float, part : Int) {
        let url : String = "http://www.marinaferry.info/MFinsertar_ticket/" + String(Int(precio * 100)) + "/" + String(part)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    	self.delegate?.ticketInsertado(diccionario)
                }
            }
    }
    
    func MFinsertar_ticket_masivo(_ precio : Float, cantidad : Int) {
        let url : String = "http://www.marinaferry.info/MFinsertar_tickets_masivos/" + String(Int(precio * 100)) +
            "/" + String(cantidad)
        Alamofire.request(url)
            .responseJSON { response in
                if case  let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.ticketsInsertadosMasivos(diccionario)
                }
            }
    }
    //url(r'^MFrecuperar_ticket/(\d{1,})/$', MFrecuperarTicket),
    //data = {'error' : 0, 'numero' : numero, 'precio' : float(ticket.precio), 'fecha' : datetime.strftime(ticket.fecha, "%H:%M:%S"), 'punto_venta' : 1, 'vendedor' : 1, 'particular' : ticket.part, 'blanco' : ticket.blanco}
    func MFrecuperar_ticket(_ numero : Int) {
        let url : String = "http://www.marinaferry.info/MFrecuperar_ticket/" + String(numero)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccinario as [String : AnyObject] = response.result.value {
                    self.delegate?.ticketRecuperado(diccinario)
                }
            }
    }
    
    //url(r'^MFborrar_ticket/(\d{1,})/$', MFborrarTicket),
    //data = {'error' : 0, 'numero' : numero, 'precio' : float(ticket.precio), 'fecha' : datetime.strftime(ticket.fecha,"%H:%M:%S")}
    func MFborrar_ticket(_ numero : Int, modo : String) {
        let url : String = "http://www.marinaferry.info/MFborrar_ticket/" + String(numero)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.ticketBorrado(diccionario, modo: modo)
                }
        }
    }
    
    //
    func MFmodificar_ticket(_ numero : Int, precio : Float) {
        let url : String = "http://www.marinaferry.info/MFmodificar_ticket/" + String(numero) + "/" +
                  String(Int(precio + 100)) 
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.ticketModificado(diccionario)
                }
        }
    }
    //url(r'^MFlistado/(\d{1,2})/(\d{1,2})/(\d{1,2})/(\d{1,2})/(\d{1,2})/(\d{1,2})/$', MFlistado),
    // datos = {'numero' : ticket.numero, 'precio' : float(ticket.precio), 'fecha' : datetime.strftime(ticket.fecha, "%d-%m-%Y %H:%M:%S"), 'punto_venta' : 1, 'vendedor' : 1, 'particular' : ticket.part, 'blanco' : ticket.blanco}
        //dict_tickets[str(i)] = datos
    func MFlistado(_ diaI : Int, mesI : Int, anyoI : Int, diaF : Int, mesF : Int, anyoF : Int) {
        let url : String = "http://www.marinaferry.info/MFlistado/" + String(diaI) + "/" + String(mesI) + "/" + String(anyoI) + "/" + String(diaF) + "/" + String(mesF) + "/" + String(anyoF)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.listadoMF(diccionario)
                }
                
        }
    }

    
    //url(r'^MFeuros/(\d{1,2})/(\d{1,2})/(\d{1,2})/(\d{1,2})/(\d{1,2})/(\d{1,2})/$', MFeuros),
    //datos = {'error' : 0, 'total' : total}
    func MFeuros(_ diaI : Int, mesI : Int, anyoI : Int, diaF : Int, mesF : Int, anyoF : Int) {
        let url : String = "http://www.marinaferry.info/MFeuros/" + String(diaI) + "/" + String(mesI) + "/" + String(anyoI) + "/" + String(diaF) + "/" + String(mesF) + "/" + String(anyoF)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : Float] = response.result.value {
                    self.delegate?.euros(diccionario)
                }
                
        }
    }
    
    ///url(r'^MFmedia/(\d{1,2})/(\d{1,2})/(\d{1,2})/(\d{1,2})/(\d{1,2})/(\d{1,2})/$', MFmedia),
    //datos = {'error' : 0, 'media' : media}
    func MFmedia(_ diaI : Int, mesI : Int, anyoI : Int, diaF : Int, mesF : Int, anyoF : Int) {
        let url : String = "http://www.marinaferry.info/MFmedia/" + String(diaI) + "/" + String(mesI) + "/" + String(anyoI) + "/" + String(diaF) + "/" + String(mesF) + "/" + String(anyoF)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : Float] = response.result.value {
                    self.delegate?.media(diccionario)
                }
                
        }


    }
    
    func MFnumeroTickets(_ diaI : Int, mesI : Int, anyoI : Int, diaF : Int, mesF : Int, anyoF : Int) {
        let url : String = "http://www.marinaferry.info/MFnum_tickets/" + String(diaI) + "/" + String(mesI) + "/" + String(anyoI) + "/" + String(diaF) + "/" + String(mesF) + "/" + String(anyoF)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : Int] = response.result.value {
                    self.delegate?.numeroTickets(diccionario)
                }
                
        }
        
        
    }
    
    ///  url(r'^MFestadisticas/(\d{1,2})/(\d{1,2})/(\d{1,2})/(\d{1,2})/(\d{1,2})/(\d{1,2})/$'
    /// datos = {'error' : 0, 'media' : media, 'total_tickets' : total_tickets, 'euros' : total_euros}
    func MFestadisticas(_ diaI : Int, mesI : Int, anyoI : Int, diaF : Int, mesF : Int, anyoF : Int) {
        let url : String = "http://www.marinaferry.info/MFestadisticas/" + String(diaI) + "/" + String(mesI) + "/" + String(anyoI) + "/" + String(diaF) + "/" + String(mesF) + "/" + String(anyoF)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.estadisticas(diccionario)
                }
                
        }
    
    }
}

class webServiceCallAPI_LB: NSObject {
    var delegate : datosBDD_LB?
    
    func LBlistado(_ diaI : Int, mesI : Int, anyoI : Int, diaF : Int, mesF : Int, anyoF : Int) {
        let url : String = "http://www.marinaferry.info/LBlistado/" + String(diaI) + "/" + String(mesI) + "/" + String(anyoI) + "/" + String(diaF) + "/" + String(mesF) + "/" + String(anyoF)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.listadoLB (diccionario)
                }
                
        }
    }
    
    func LBlistadoB(_ diaI : Int, mesI : Int, anyoI : Int, diaF : Int, mesF : Int, anyoF : Int) {
        let url : String = "http://www.marinaferry.info/LBlistadoB/" + String(diaI) + "/" + String(mesI) + "/" + String(anyoI) + "/" + String(diaF) + "/" + String(mesF) + "/" + String(anyoF)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.listadoLB (diccionario)
                }
                
        }
    }

    // Devuelve las estadisticas de la oficina en negro
    func LBestadisticas(_ diaI : Int, mesI : Int, anyoI : Int, diaF : Int, mesF : Int, anyoF : Int) {
        let url : String = "http://www.marinaferry.info/LBestadisticas/" + String(diaI) + "/" + String(mesI) + "/" + String(anyoI) + "/" + String(diaF) + "/" + String(mesF) + "/" + String(anyoF)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.estadisticas(diccionario)
                }
                
        }
        
    }
    
    // Devuelve las estadisticas de la oficina en blanco
    func LBestadisticasB(_ diaI : Int, mesI : Int, anyoI : Int, diaF : Int, mesF : Int, anyoF : Int) {
        let url : String = "http://www.marinaferry.info/LBestadisticasB/" + String(diaI) + "/" + String(mesI) + "/" + String(anyoI) + "/" + String(diaF) + "/" + String(mesF) + "/" + String(anyoF)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.estadisticas(diccionario)
                }
                
        }
        
    }
    
    // Devuelve estadisticas totales en negro
    func LBestadisticasTotales(_ diaI : Int, mesI : Int, anyoI : Int, diaF : Int, mesF : Int, anyoF : Int) {
        let url : String = "http://www.marinaferry.info/LBestadisticasTotales/" + String(diaI) + "/" + String(mesI) + "/" + String(anyoI) + "/" + String(diaF) + "/" + String(mesF) + "/" + String(anyoF)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.estadisticasTotales(diccionario)
                }
                
        }

    }
    
    // Devuelve estadisticas totales en blanco
    func LBestadisticasTotalesB(_ diaI : Int, mesI : Int, anyoI : Int, diaF : Int, mesF : Int, anyoF : Int) {
        let url : String = "http://www.marinaferry.info/LBestadisticasTotalesB/" + String(diaI) + "/" + String(mesI) + "/" + String(anyoI) + "/" + String(diaF) + "/" + String(mesF) + "/" + String(anyoF)
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.estadisticasTotales(diccionario)
                }
                
        }
        
    }

    
    // Inserta un viaje en la BDD de LB. Si blanco = 1 el tiquet es blanco
    func LBinsertar_viaje(_ precio : Float, tipo : Int, blanco : Int = 1) {
        let pre = String(Int(precio * 100))
        let url : String = "http://www.marinaferry.info/LBinsertar_viaje/" + pre + "/" + String(tipo) + "/" +  String(blanco)
        Alamofire.request(url)
            .responseJSON { response in
                //print(response.result.value)
                if case let diccionario as [String : AnyObject] = response.result.value {
                   	self.delegate?.viajeInsertado(diccionario)
                } else {
                    self.delegate?.viajeInsertado(["error" : "no hay conexión" as AnyObject])
                }
        }
    }
    
    func LBreservasDia() {
        let url : String = "http://www.marinaferry.info/barcas_dia"
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.barcasDia(diccionario)
                }
                
        }
    }
    
    func cierre() {
        let url : String = "http://www.marinaferry.info/cierre_dia"
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : String] = response.result.value {
                    self.delegate?.cierre(diccionario)
                }
        }
    }
    
    func LBincrementarReserva(tipo : Int) {
        let url : String = "http://www.marinaferry.info/incrementar_reserva/" + String(tipo) + "/"
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.reservaIncrementada(diccionario)
                }
                
        }
    }

}


class webServiceCallApiR : NSObject {
    var delegate : datosBDD_R?
    
    func LBnumeroReserva(_ tipo : Int) {
        let url : String = "http://www.marinaferry.info/reserva/" + String(tipo) + "/1"
        Alamofire.request(url)
            .responseJSON { response in
                if case let diccionario as [String : AnyObject] = response.result.value {
                    self.delegate?.obtenerNumeroReserva(diccionario)
                } 
        }
        
        
    }
}

class webServiceCallApiLS : NSObject {
        var delegate : datosBDD_LS?

        func obtenerListadoSalidas(_ tipo : Int) {
            var tipo_barca : String = ""
            if tipo == 1 {
                tipo_barca = "Rio"
            } else if tipo == 2 {
                tipo_barca = "Barca"
            } else if tipo == 3 {
                tipo_barca = "Gold"
            }
            let url : String = "http://www.marinaferry.info/listado_reservas/" + String(tipo_barca)
        
            Alamofire.request(url)
                .responseJSON { response in
                    if case let diccionario as [String : AnyObject] = response.result.value {
                        self.delegate?.listadoSalidas(diccionario)
                    }
            }
        
    }
}


