//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(price: String, currency: String)
    func didFailWithError(_ coin: CoinManager, error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "BCF41E4A-6DF1-4EB7-965E-CA3B087BC6CE"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString, currency: currency)
    }
    
    func performRequest(with urlString: String, currency: String){
        //Create URL
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    //self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let rate = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCoin(price: String(format: "%.2f", rate), currency: currency)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            
            return lastPrice
        }catch{
            delegate?.didFailWithError(self, error: error)
            return nil
        }
        
    }
    
}
