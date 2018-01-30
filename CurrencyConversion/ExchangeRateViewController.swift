//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Naga Mullapudi on 2018-01-21.
//

import UIKit

class ExchangeRateViewController: UIViewController {

    var viewModel: ExchangeRateViewModel = ExchangeRateViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var baseButtonItem: UIBarButtonItem!
    @IBOutlet weak var networkFetch: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.text = "1.0"
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: - Network Call
extension ExchangeRateViewController {
    func loadData(with base: String = "CAD") {
        viewModel.loadExchangeRates(with: base) { [weak self] (error) in
            guard let strongSelf = self else {
                assertionFailure("missing self")
                return
            }
            guard let activeExchangeBase = strongSelf.viewModel.activeCurrencyInfo else {
                assertionFailure("missing essential active exchange information")
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.networkFetch.text = strongSelf.viewModel.networkFetch ? "Network Fetch" : "Local Fetch"
                strongSelf.baseButtonItem.title = activeExchangeBase.base 
                strongSelf.collectionView.reloadData()
            }
        }
    }
}

//MARK: - CollectionView DataSource and Delegate
extension ExchangeRateViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.baseStringForActiveInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "currencyCell", for: indexPath) as! CurrencyCollectionViewCell
        let countryCode = viewModel.baseStringForActiveInfo[indexPath.item]
        var value: Double = 0.0
        if let text = textField.text, let doubleValue = Double(text) {
            value = doubleValue
        }
        cell.base.text =  countryCode
        cell.currencyValue.text = "\(viewModel.currencyValue(countryCode: countryCode, value: value))"
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
}

//MARK: - TextField Delegate
extension ExchangeRateViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.collectionView.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Popover Functionality
extension ExchangeRateViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverSegue" {
            segue.destination.modalPresentationStyle = .popover
            segue.destination.popoverPresentationController?.delegate = self
            
            let popoverViewController = segue.destination as! CurrencyTypeTableViewController
            popoverViewController.delegate = self
            popoverViewController.currencyTypes = viewModel.allbaseStrings
            popoverViewController.selectedCurrency = viewModel.activeCurrencyInfo?.base
            
        }
    }
}

//MARK: - TableView Selection Delegate
extension ExchangeRateViewController: CurrencyTypeSelectionDelegate {
    func updateCollectionView(with base: String) {
        loadData(with: base)
    }
}


