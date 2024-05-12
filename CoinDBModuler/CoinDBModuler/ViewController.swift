//
//  ViewController.swift
//  CoinDBModuler
//
//  Created by Ece Ok, Vodafone on 8.05.2024.
//


import UIKit
import CoinAPI
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var filteredCollectionView: UICollectionView!
    let filteredOptions = ["24hVolume", "Price", "Market Cap","Change","listedAt"] //TODO add smt lastedat vb.-> need to formatted
    var sendCoin: ((Any) -> Void)?
  
    var viewModel: FirstViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "FirstCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "firstCoinCell")
        viewModel!.load()
        filteredCollectionView.delegate = self
        filteredCollectionView.dataSource = self
        filteredCollectionView.register(UINib(nibName: "FilteredCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "filterCell")
        filteredCollectionView.showsHorizontalScrollIndicator = false
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                    // Hücreler arası boşluk ayarı
                    layout.minimumInteritemSpacing = 10
                    layout.minimumLineSpacing = 10
                    
                    // Hücrelere sınır (border) eklemek için aşağıdaki satırları kullanabilirsiniz.
                    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    layout.itemSize = CGSize(width: (collectionView!.frame.size.width - 30) / 2, height: 100) // Hücre boyutu
                    
                    // Sınır (border) renk ve kalınlık ayarları
                    layout.sectionInsetReference = .fromSafeArea
                    layout.sectionHeadersPinToVisibleBounds = true
                    layout.footerReferenceSize = CGSize(width: 100, height: 100)
                    
                }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func navigateToCoinAndGraph(_ coin: CoinIcons, graph: [String]) {
        if let receiverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondVC") as? SecondDetailViewController{
                    receiverVC.tookCoin = coin
                    receiverVC.sendCoin = { [weak self] data in
                        print("gönderilen veri: \(data)")
                    }
            receiverVC.graphInfo = graph
            receiverVC.sendGraph = { [weak self] data in
                print("gönderilen graph: \(data)")
            }
            
            if let currentVC = UIApplication.shared.keyWindow?.rootViewController {
                       // Eğer mevcut bir navigation controller varsa, onu kullan
                       if let navController = currentVC.navigationController {
                           navController.pushViewController(receiverVC, animated: true)
                       } else {
                           // Eğer yoksa, direk mevcut görünüm denetleyicisi üzerine sun
                           currentVC.present(receiverVC, animated: true, completion: nil)
                       } 
                    }
                }
    }

}

extension ViewController: FirstViewModelDelegate {
    func reloadData() {
        collectionView.reloadData()
        
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
            var graph = [String]()
            if let selectedCoin = viewModel.coin(index: indexPath.item) {
                graph = selectedCoin.sparkline!
                if let coinName = selectedCoin.name {
                    let coin = (viewModel.fetchCoreData(coinName: coinName))!
                    navigateToCoinAndGraph(coin,graph:graph)
                }
            }
                else {
                    print("Coin ismi bulunamadı.")
                }
            
        }

}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filteredCollectionView{
            filteredOptions.count
        } else {
            viewModel.numberOfItems
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filteredCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilteredCollectionViewCell
                        cell.configure(filterType: filteredOptions[indexPath.row])
                        cell.applyFilterAction = { [weak self] in
                            guard let self = self else { return }
                            switch indexPath.row {
                            case 0:
                                self.viewModel.applyFilter(.volume24h)
                            case 1:
                                self.viewModel.applyFilter(.price)
                            case 2:
                                self.viewModel.applyFilter(.marketCap)
                            case 3:
                                self.viewModel.applyFilter(.change)
                            case 4:
                                self.viewModel.applyFilter(.listedAt)
                            default:
                                break
                            }
                        }
                        return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCoinCell", for: indexPath) as! FirstCollectionViewCell
            if let coin = viewModel.coin(index: indexPath.item){
                cell.configure(coin)
            }
            return cell
        }
        
        
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        .init(width: collectionView.frame.size.width - 10, height: 92)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 10, bottom: 0, right: 10)
    }
    
}
