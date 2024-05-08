//
//  FirstViewModel.swift
//  CoinDBModuler
//
//  Created by Ece Ok, Vodafone on 8.05.2024.
//

import Foundation
import CoinAPI
import CoreData


protocol FirstViewModelProtocol{
    
    func load()
    var delegate: FirstViewModelDelegate? { get set }
    func saveIconToCoreData(imageData: Data?, for coin: Coin)
    func loadIconDataFromCoreData(for coin: Coin) -> Data?
    func downloadAndSaveIcon(from url: URL, for coin: Coin)
}

protocol FirstViewModelDelegate: AnyObject {
    func reloadData()
}

final class FirstViewModel {
    let service: CoinServiceProtocol
    var coins = [Coin]()
    weak var delegate: FirstViewModelDelegate?
    let coreDataManager = CoreDataManager.shared
    
        
   
    
    init(service: CoinServiceProtocol) {
            self.service = service
        }
    
    fileprivate func fetchCoins() {
        //self.delegate?.showLoadingView() // Loading Göster haberini VC a verir
        service.fetchCoins { [weak self] response in
            
            guard let self else { return }
            
            switch response {
            case .success(let coins):
                //self.delegate?.hideLoadingView() // Loading Gizle haberini VC a verir
                DispatchQueue.main.async {
                    self.coins = coins
                    self.delegate?.reloadData() // Collectionview Reload et haberini VC a verir
                }
                print(coins)
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
            }
        }
    }

        
}

extension FirstViewModel : FirstViewModelProtocol {
    func saveIconToCoreData(imageData: Data?, for coin: CoinAPI.Coin) {
        guard let imageData = imageData else { return }
        let context =  coreDataManager.persistentContainer.viewContext

        guard let newIcon = NSEntityDescription.insertNewObject(forEntityName: "CoinIcons", into: context) as? CoinIcons else {
                print("Error creating new CoreIcons object")
                return
            }
            newIcon.setValue(coin.name, forKey: "coinName")
            newIcon.setValue(imageData, forKey: "image")
            CoreDataManager.shared.saveContext()
    }
    
    func loadIconDataFromCoreData(for coin: CoinAPI.Coin) -> Data? {
        <#code#>
    }
    
    func downloadAndSaveIcon(from url: URL, for coin: CoinAPI.Coin) {
        URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error downloading icon: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // İndirilen veriyi Core Data'ya belirli bir anahtarla kaydet
                self.saveIconToCoreData(imageData: data, forKey: key, for: coin)
            }.resume()
    }
    
    

    func load() {
        fetchCoins()
    }
    
    
    
    
}
