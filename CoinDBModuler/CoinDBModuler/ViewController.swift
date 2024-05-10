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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

  
}

extension ViewController: FirstViewModelDelegate {
   
    
    func reloadData() {
        collectionView.reloadData()
        
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(movies[indexPath.row].title ?? "")
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
