//
//  PopularMentionTableViewController.swift
//  Smashtag
//
//  Created by Samuel Navamani on 19/9/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit
import CoreData

class PopularMentionTableViewController: UITableViewController {

    var searchTerm: String? { didSet { updateUI() } }
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer { didSet { updateUI() } }
    
    var fetchedResultsController: NSFetchedResultsController<Mentions>?
    
    private func updateUI() {
        if let context = container?.viewContext, let mention = searchTerm {
            let request: NSFetchRequest<Mentions> = Mentions.fetchRequest()
            request.sortDescriptors =
                [
                NSSortDescriptor(key: "type", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:))),
                NSSortDescriptor(key: "count", ascending: false),
                NSSortDescriptor(key: "keyword", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
            ]
            request.predicate = NSPredicate(format: "any searchterm contains[c] %@", mention)
            
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: "type",
                cacheName: nil)
        }
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularMentionCell", for: indexPath)
        
        if let mentions = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = mentions.keyword
            cell.detailTextLabel?.text = "\(mentions.count)"
        }
        return cell
    }
    
}

extension PopularMentionTableViewController
{
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sections = fetchedResultsController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {   if let sections = fetchedResultsController?.sections, sections.count > 0 {
        return sections[section].name
    } else {
        return nil
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        return fetchedResultsController?.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int
    {
        return fetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
}

