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
    
    @IBOutlet weak var filteredPicker: UIPickerView!
    let filteredOptions = ["24hVolume", "Price", "Market Cap","Change"] //TODO add smt lastedat vb.-> need to formatted
    var sendCoin: ((Any) -> Void)?
  
    var viewModel: FirstViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "FirstCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "firstCoinCell")
        viewModel!.load()
        filteredPicker.delegate = self
        filteredPicker.dataSource = self
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
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCoinCell", for: indexPath) as! FirstCollectionViewCell
        if let coin = viewModel.coin(index: indexPath.item){
            cell.configure(coin)
          }
          return cell
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

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Tek bir sütun
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filteredOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filteredOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Seçilen filtre seçeneğine göre filtreleme işlemini gerçekleştirin
        switch row {
        case 0: // 24h Volume
            viewModel.applyFilter(.volume24h)
        case 1: // Price
            viewModel.applyFilter(.price)
        case 2: // Market Cap
            viewModel.applyFilter(.marketCap)
        case 3: //change
            viewModel.applyFilter(.change)
        default:
            break
        }
    }
}
