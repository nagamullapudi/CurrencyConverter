//
//  CurrencyTypeTableViewController.swift
//  CurrencyConverter
//
//  Created by Naga Mullapudi on 2018-01-22.
//

import UIKit

protocol CurrencyTypeSelectionDelegate: class {
    func updateCollectionView(with base: String)
}

class CurrencyTypeTableViewController: UITableViewController {
    
    weak var delegate: CurrencyTypeSelectionDelegate?
    var selectedIndexPath: IndexPath?
    
    var currencyTypes: [String]?
    var selectedCurrency: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false

        self.tableView.tableFooterView = nil
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let types = currencyTypes else {
            return 0
        }
        return types.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyType", for: indexPath)
        cell.textLabel?.text = currencyTypes?[indexPath.row]
        cell.accessoryType = .none

        if currencyTypes?[indexPath.row] == selectedCurrency {
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if let sIndexPath = selectedIndexPath {
            let selectedCell = tableView.cellForRow(at: sIndexPath)
            selectedCell?.accessoryType = .none
        }
        
        self.selectedCurrency = self.currencyTypes?[indexPath.row]
        cell?.accessoryType = .checkmark
        
        if let selected = self.selectedCurrency {
            self.delegate?.updateCollectionView(with: selected)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
