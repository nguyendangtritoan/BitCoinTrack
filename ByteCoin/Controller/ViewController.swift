//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinLable: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    //Need to change this to a var to be able to modify its properties.
    var coinManger = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManger.delegate = self
    }

}

extension ViewController: CoinManagerDelegate{
    func didUpdateCoin(price: String, currency: String) {
        DispatchQueue.main.async {
            self.bitcoinLable.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(_ coin: CoinManager, error: Error) {
        print(error)
    }
}

extension ViewController:UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManger.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManger.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManger.getCoinPrice(for: coinManger.currencyArray[row])
    }
}
