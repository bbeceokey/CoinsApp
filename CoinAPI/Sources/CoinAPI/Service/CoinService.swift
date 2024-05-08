//
//  CoinService.swift
//
//
//  Created by Ece Ok, Vodafone on 8.05.2024.
//



import Foundation
import Alamofire

public protocol CoinServiceProtocol {
    func fetchCoins(completion: @escaping (Result<[Coin], Error>) -> Void)
    //TODO: image url fetch
}

public class CoinService: CoinServiceProtocol {
   
    
    
    public init() {}
    
    public func fetchCoins(completion: @escaping (Result<[Coin], Error>) -> Void) {
        
        let urlString = "https://psp-merchantpanel-service-sandbox.ozanodeme.com.tr/api/v1/dummy/coins"
        
        AF.request(urlString).responseData { [weak self] response in
            guard let self else { return }
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    let coinsResponse = try decoder.decode(CoinsResponse.self, from: data)
                    completion(.success(coinsResponse.datas.coins))
                } catch {
                    print("JSON decode hatası: \(error)")
                    completion(.failure(error))
                    print("******* JSON DECODE ERROR ******")
                }
                
            case .failure(let error):
                print("***** Lütfen daha sonra tekrar deneyiniz..****")
            }
            
        }
        
        
    }
    
}
