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

enum FilterType {
    case price
    case marketCap
    case volume24h
    case change
    case listedAt
}

protocol FirstViewModelProtocol{
    func applyFilter(_ filterType: FilterType)
    func load()
    var delegate: FirstViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    func coin(index: Int) -> CoinAPI.Coin?
    func fetchCoreData(coinName: String) -> CoinIcons?
    func applyListedAtFilter()
    
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
    let dateFormatter = DateFormatter()

    init(service: CoinServiceProtocol) {
            self.service = service
        }
    
    func coinsDateFormatted(coins: [Coin]?) -> [Date]? {
        guard let coins = coins else {
               return nil
           }
           
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           
           var dateArray: [Date] = []
           for coin in coins {
               if let listedAtUnix = coin.listedAt {
                   let date = Date(timeIntervalSince1970: TimeInterval(listedAtUnix))
                   print(coin.name)
                   print(date)
                   dateArray.append(date)
               }
           }
        let sortedDates = dateArray.sorted(by: { $0.compare($1) == .orderedDescending })
        return sortedDates
    
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
            newIcon.rank = Int32(coin.rank!)
            newIcon.price = coin.price
            newIcon.market = coin.marketCap
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
    
    func applyFilter(_ filterType: FilterType) {
        // listedAt durumunda özel sıralama işlemi gerçekleştirilir
            // Diğer filtre türleri için standart sıralama işlemi gerçekleştirilir
            switch filterType {
            case .price:
                coins.sort { Double($0.price!)! > Double($1.price!)! }
            case .marketCap:
                coins.sort { Double($0.marketCap!)! > Double($1.marketCap!)! }
            case .volume24h:
                coins.sort { Double($0.marketCap!)! > Double($1.marketCap!)!}
            case .change:
                coins.sort {Double($0.change!)! > Double($1.change!)!  }
            default:
                break
            }
        self.delegate?.reloadData()
        }

    func applyListedAtFilter() {
        coins = coins.sorted { coin1, coin2 in
            guard let listedAt1Unix = coin1.listedAt,
                  let listedAt2Unix = coin2.listedAt else {
                return false // Eğer listedAt değerleri eksikse, sıralamayı değiştirmeyin
            }
            
            let listedAt1 = Date(timeIntervalSince1970: TimeInterval(listedAt1Unix))
            let listedAt2 = Date(timeIntervalSince1970: TimeInterval(listedAt2Unix))
            
            return listedAt1 > listedAt2
        }
        
        // Delegate'e verilerin yeniden yükleneceğini bildir
        DispatchQueue.main.async {
            self.delegate?.reloadData()
        }
    }



        func fetchCoreData(coinName: String) -> CoinIcons?{
            guard let coreCoinDatas = coreDataManager.fetchData() else {
                return nil
            }
            for coin in coreCoinDatas {
                if coin.iconName == coinName {
                    print("coredatadan çekildi", coin.price)
                    return coin
                }
            }
            return nil
        }
        
    }

