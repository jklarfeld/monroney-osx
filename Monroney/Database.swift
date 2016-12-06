//
//  Database.swift
//  Monroney
//
//  Created by Jeffrey Klarfeld on 12/5/16.
//  Copyright © 2016 Jeffrey Klarfeld. All rights reserved.
//

import Foundation
import CoreData
import AppKit.NSApplication

class Database
{
	// MARK: Singleton	
	static let shared: Database = Database()
	
	lazy private var applicationDocumentsDirectory: Foundation.URL =
	{
		let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
		let appSupportURL = urls[urls.count - 1]
		return appSupportURL.appendingPathComponent("com.jklarfeld.Monroney")
	}()
	
	lazy private var managedObjectModel: NSManagedObjectModel =
	{
		let modelURL = Bundle.main.url(forResource: "Monroney", withExtension: "momd")!
		return NSManagedObjectModel(contentsOf: modelURL)!
	}()
	
	lazy private var persistentStoreCoordinator: NSPersistentStoreCoordinator =
	{
		let fileManager = FileManager.default
		var failError: NSError? = nil
		var shouldFail = false
		var failureReason = "There was an error creating or loading the application's saved data."
		
		// Make sure the application files directory is there
		do
		{
			let properties = try self.applicationDocumentsDirectory.resourceValues(forKeys: [URLResourceKey.isDirectoryKey])
			if !properties.isDirectory!
			{
				failureReason = "Expected a folder to store application data, found a file \(self.applicationDocumentsDirectory.path)."
				shouldFail = true
			}
		}
		catch
		{
			let nserror = error as NSError
			if nserror.code == NSFileReadNoSuchFileError
			{
				do
				{
					try fileManager.createDirectory(atPath: self.applicationDocumentsDirectory.path, withIntermediateDirectories: true, attributes: nil)
				}
				catch
				{
					failError = nserror
				}
			}
			else
			{
				failError = nserror
			}
		}
		
		// Create the coordinator and store
		var coordinator: NSPersistentStoreCoordinator? = nil
		if failError == nil
		{
			coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
			let url = self.applicationDocumentsDirectory.appendingPathComponent("Monroney.storedata")
			do
			{
				try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType,
				                                    configurationName: nil,
				                                    at: url,
				                                    options: nil)
			}
			catch
			{
				// Replace this implementation with code to handle the error appropriately.
				failError = error as NSError
			}
		}
		
		if shouldFail || (failError != nil)
		{
			// Report any error we got.
			if let error = failError
			{
				NSApplication.shared().presentError(error)
				fatalError("Unresolved error: \(error), \(error.userInfo)")
			}
			
			fatalError("Unsresolved error: \(failureReason)")
		}
		else
		{
			return coordinator!
		}
	}()
	
	lazy var mainContext: NSManagedObjectContext =
	{
		let coordinator = self.persistentStoreCoordinator
		var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = coordinator
		return managedObjectContext
	}()
}
