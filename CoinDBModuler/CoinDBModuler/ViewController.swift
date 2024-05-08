//
//  ViewController.swift
//  CoinDBModuler
//
//  Created by Ece Ok, Vodafone on 8.05.2024.
//

import UIKit
import CoinAPI

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
  
    var viewModel: FirstViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel!.load()
    }
  
}

extension ViewController: FirstViewModelDelegate {
    
    
    func reloadData() {
        collectionView.reloadData()
    }
    
}
