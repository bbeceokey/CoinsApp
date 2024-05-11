//
//  SecondDetailViewController.swift
//  CoinDBModuler
//
//  Created by Ece Ok, Vodafone on 11.05.2024.
//

import UIKit

class SecondDetailViewController: UIViewController {
    
    var tookCoin : CoinIcons?
    var graphInfo : [String]?
    var sendCoin: ((Any) -> Void)?
    var sendGraph: ((Any) -> Void)?
    var viewModel = SecondDetailViewModel()
    @IBOutlet weak var coinDetailView: CoinView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tookCoin = tookCoin {
            sendCoin?(tookCoin)
            print("coin geldi", tookCoin)
        }
        if let graphInfo = graphInfo {
            sendGraph?(graphInfo)
            print("graph geldi" , graphInfo)
        }
        viewModel.configure(with: tookCoin!, graphInfo: graphInfo!)
        coinDetailView.setupView(with: viewModel)

    }

}
