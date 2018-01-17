//
//  ViewController.swift
//  CurrencyConversion
//
//  Created by Naga Sai Jyothi  on 2017-12-16.
//  Copyright © 2017 Naga Sai Jyothi . All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    let container = Container()
    var convertedRate: String = ""
    var convertFromCurrencyType = "CAD"
    var  count:Int = 0
    @IBOutlet weak var conversionNumber: UITextField!
    @IBOutlet weak var convertFromCurrencyTypeBtn: UIButton!
    @IBOutlet weak var convertToCurrencyType: UIButton!
    @IBOutlet weak var displayConvertedRate: UILabel!
    var selectedButton: UIButton!

    @IBAction func convertButtonPressed(_ sender: Any) {
        guard let from = self.convertFromCurrencyTypeBtn.titleLabel?.text,
        let to = self.convertToCurrencyType.titleLabel?.text else {
            return
        }
        guard let conversionNumber = self.conversionNumber.text, !conversionNumber.isEmpty else {
            self.displayConvertedRate.text = "Please fill the number Field"
            return
        }
        let myString = self.conversionNumber.text
        let myFloat = (myString! as NSString).floatValue
        self.container.convert(convertFromCurrencyType: from, convertToCurrencyType: to, conversionNumber: myFloat, completion:{ (string, error) in
            DispatchQueue.main.async {
                self.displayConvertedRate.text = string
            }
        })
        print("Convered Rate :  \(self.convertedRate)")
    }
    
    
    @IBAction func baseCurrncyTypeBtnPressed(_ sender: UIButton) {
        self.selectedButton = sender
        let currencyListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CurrencyListVC") as! CurrencyList
        currencyListVC.delegate = self
        self.navigationController?.pushViewController(currencyListVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateButtonTitle(button: UIButton, text: String) {
        button.setTitle(text, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: CurrencyListDelegate {
    func currenyList(viewController: CurrencyList, selectedCurrencyList: String) {
        self.updateButtonTitle(button: self.selectedButton, text: selectedCurrencyList)
    }
}

