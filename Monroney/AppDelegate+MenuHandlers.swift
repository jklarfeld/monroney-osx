//
//  AppDelegate+MenuHandlers.swift
//  Monroney
//
//  Created by Jeffrey Klarfeld on 12/4/16.
//  Copyright © 2016 Jeffrey Klarfeld. All rights reserved.
//

import AppKit

extension AppDelegate
{
	@IBAction func newMenuItem(_ sender: NSMenuItem)
	{
		let newWindowController = MainWindowController(windowNibName: "MainWindow", owner: self)
		
		additionalWindows.append(newWindowController)
		
		newWindowController.showWindow(self)
	}
}
