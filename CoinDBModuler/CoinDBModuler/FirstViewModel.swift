//
//  FirstViewModel.swift
//  CoinDBModuler
//
//  Created by Ece Ok, Vodafone on 8.05.2024.
//
import Foundation
import CoinAPI
import CoreData

extension String {
    func replacingSVGWithPNG() -> String {
        return self.replacingOccurrences(of: ".svg", with: ".png")
    }
}

protocol FirstViewModelProtocol{
    func load()
    var delegate: FirstViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    func coin(index: Int) -> CoinAPI.Coin?
    
}

protocol FirstViewModelDelegate: AnyObject {
   
    func reloadData()
}

final class FirstViewModel {
    let service: CoinServiceProtocol
    var coins = [Coin]()
    weak var delegate: FirstViewModelDelegate?
    let coreDataManager = CoreDataManager.shared
    let dispatchGroup = DispatchGroup()

    init(service: CoinServiceProtocol) {
            self.service = service
        }
    
    func fetchCoinsAndIcons() {
        
        self.dispatchGroup.enter()
        
           service.fetchCoins { [weak self] response in
               guard let self = self else { return }
               
               switch response {
               case .success(let coins):
                   self.coins = coins
                   
                   self.dispatchGroup.notify(queue: .main) {
                           // CoreData'ye ikonlar kaydedildikten sonra hücreleri configure et
                       
                           self.delegate?.reloadData()
                       }
                   
                   self.saveIconToCoreData( for: coins)
               case .failure(let error):
                   print("Error: \(error.localizedDescription)")
               }
           }
        self.dispatchGroup.leave()
       }
    
    
    
    func saveIconToCoreData(for coins: [CoinAPI.Coin]) {
        let context = coreDataManager.persistentContainer.viewContext
        
        for coin in coins {
            let newIcon = CoinIcons(context: context)
            newIcon.iconName = coin.name
            newIcon.url = coin.iconUrl
            newIcon.changeRate = coin.change
            newIcon.grafik = [coin.sparkline] as NSObject
            newIcon.rank = Int32(coin.rank!)
            coreDataManager.saveContext()
        }
        
        }
    
    


}

extension FirstViewModel : FirstViewModelProtocol {
    
    func load() {
        DispatchQueue.global().async {
            self.fetchCoinsAndIcons()
    }
    }

    var numberOfItems: Int {
        coins.count
    }
    
    func coin(index: Int) -> CoinAPI.Coin? {
        coins[index]
    }
    
    
}
