//
//  AppDelegate.swift
//  Monroney
//
//  Created by Jeffrey Klarfeld on 11/28/16.
//  Copyright © 2016 Jeffrey Klarfeld. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	// MARK: - NSApplicationDelegate
	
	func applicationDidFinishLaunching(_ aNotification: Notification)
	{
		self.showMainWindow()
	}

	func applicationWillTerminate(_ aNotification: Notification)
	{
		
	}
	
	func applicationShouldTerminate(_ sender: NSApplication) -> NSApplicationTerminateReply
	{
		let context = Database.shared.mainContext
		
		if !context.commitEditing()
		{
			NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
			return .terminateCancel
		}
		
		if !context.hasChanges
		{
			return .terminateNow
		}
		
		do
		{
			try context.save()
		}
		catch
		{
			let nserror = error as NSError
			// Customize this code block to include application-specific recovery steps.
			let result = sender.presentError(nserror)
			
			if (result)
			{
				return .terminateCancel
			}
			
			let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
			let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
			
			let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
			let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
			
			let alert = NSAlert()
			alert.messageText = question
			alert.informativeText = info
			alert.addButton(withTitle: quitButton)
			alert.addButton(withTitle: cancelButton)
			
			let answer = alert.runModal()
			if answer == NSAlertSecondButtonReturn
			{
				return .terminateCancel
			}
		}
		// If we got here, it is time to quit.
		return .terminateNow
	}
	
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool
	{
		return true
	}
	
	// MARK: - Instance Methods
	
	private func showMainWindow()
	{
		mainWindowController.showWindow(self)
	}

	// MARK: - Core Data Saving and Undo support

	@IBAction func saveAction(_ sender: AnyObject?)
	{
		let context = Database.shared.mainContext
		
	    if !context.commitEditing()
		{
	        NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
	    }
	    if context.hasChanges
		{
	        do
			{
	            try context.save()
	        }
			catch
			{
	            let nserror = error as NSError
	            NSApplication.shared().presentError(nserror)
	        }
	    }
	}

	func windowWillReturnUndoManager(window: NSWindow) -> UndoManager?
	{
		return Database.shared.mainContext.undoManager
	}
	
	// MARK: - Properties
	
	let mainWindowController: MainWindowController = MainWindowController(windowNibName: "MainWindow")
	
	var additionalWindows: [MainWindowController] = []
}

