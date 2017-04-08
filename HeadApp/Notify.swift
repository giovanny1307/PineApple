//
//  Notify.swift
//  HeadApp
//
//  Created by Giovanny Piñeros on 12/10/15.
//  Copyright © 2015 Giovanny Piñeros. All rights reserved.
//


import UIKit


class Notify {
	
	class func pine(_ mensaje: String, contador: Int){
		//let now: NSDateComponents = NSCalendar.currentCalendar().components([.Day], fromDate: NSDate())
		
		
		
		let components = DateComponents()
		(components as NSDateComponents).setValue(contador,forComponent: NSCalendar.Unit.day)
		let date : Date = Date()
		let firedate = (Calendar.current as NSCalendar).date(byAdding: components, to: date, options: NSCalendar.Options(rawValue: 0))
		
		let reminder = UILocalNotification()
		reminder.fireDate = firedate
		reminder.alertBody = mensaje
		reminder.alertTitle = "Hey! " + nombreUsuario()
		reminder.soundName = "sound.aif"
	

		UIApplication.shared.scheduleLocalNotification(reminder)
		
		

		print(firedate!)
	
	}
	
	class func nombreUsuario() ->String{
	
	let ud: UserDefaults = UserDefaults.standard
		
		if(ud.string(forKey: "Nombre") == nil){ return " "}else{ return ud.string(forKey: "Nombre")!}
	
	}

	
	
}
