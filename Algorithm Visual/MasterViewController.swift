//
//  MasterViewController.swift
//  Algorithm Visual
//
//  Created by Ryan Schumacher on 11/23/16.
//  Copyright © 2016 Schumacher. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    let entries: [(algorithm: (Int) -> Algorithm, name: String, size: Int, rate: Double)] = [
        (algorithm: BubbleSortAlgorithm.init, name: "Bubble Sort", size: 50, rate: 0.1),
        (algorithm: MergeSortAlgorithm.init, name: "Merge Sort", size: 350, rate: 0.1),
        (algorithm: QuickSortAlgorithm.init, name: "Quick Sort", size: 50, rate: 1.0)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {

                let entry = entries[indexPath.row]
                let algroithm = entry.algorithm(entry.size)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.title = entry.name
                controller.scene = algroithm.generateScene(rate: entry.rate)
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .blue
        let entry = entries[indexPath.row]

        cell.textLabel?.text = entry.name

        return cell
    }
}
