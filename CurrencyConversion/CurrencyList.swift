//
//  CurrencyList.swift
//  CurrencyConversion
//
//  Created by Naga Sai Jyothi  on 2017-12-17.
//  Copyright © 2017 Naga Sai Jyothi . All rights reserved.
//

import UIKit

protocol CurrencyListDelegate: class {
    func currenyList(viewController: CurrencyList, selectedCurrencyList: String)
}

class CurrencyList: UITableViewController {

    let container = Container()
    var keys:[String] = []
    weak var delegate: CurrencyListDelegate?
    
    override func viewDidLoad() {
        self.container.currencyList(complition:{(error)in DispatchQueue.main.async {
            self.keys = self.container.keys
            self.tableView.reloadData()

            }
        })
        super.viewDidLoad()
        print("Keys: \(self.keys)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.container.keys.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CurrencyListTableViewCell
       cell.cellLabel.text = self.keys[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCurrencyType = keys[indexPath.row]
        self.delegate?.currenyList(viewController: self, selectedCurrencyList: selectedCurrencyType)
        self.navigationController?.popViewController(animated: true)
    }
}
