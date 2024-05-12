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
    @IBOutlet weak var emptyGraphView: UIView!
    
    var graphView : GraphView!
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView = GraphView(frame: emptyGraphView.bounds)
        emptyGraphView.backgroundColor = UIColor.systemGray6
        emptyGraphView.layer.borderWidth = 0.5
        emptyGraphView.layer.borderColor = UIColor.orange.cgColor
    
        emptyGraphView.addSubview(graphView!)
        if let tookCoin = tookCoin {
            sendCoin?(tookCoin)
            print("coin geldi", tookCoin)
        }
        if let graphInfo = graphInfo {
            sendGraph?(graphInfo)
            let cgFloatArray = graphInfo.compactMap { CGFloat(Float($0) ?? 0.0) }
            graphView.dataPoints = cgFloatArray
           
            print("graph geldi" , graphInfo)
        }
        viewModel.configure(with: tookCoin!, graphInfo: graphInfo!)
        coinDetailView.setupView(with: viewModel)

    }
    


   

}
