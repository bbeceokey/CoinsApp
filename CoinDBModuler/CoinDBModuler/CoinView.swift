//
//  CoinView.swift
//  CoinDBModuler
//
//  Created by Ece Ok, Vodafone on 11.05.2024.
//

import UIKit

class CoinView: UIView {

    @IBOutlet weak var currentPrice: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var high: UILabel!
    @IBOutlet weak var changeRate: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureView() {
        guard let nibView = loadViewfromNib() else { return }
        containerView = nibView
        bounds = nibView.frame
        addSubview(nibView)
    }
    private func loadViewfromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let name = NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
        let nib = UINib(nibName: name, bundle: bundle)
        let view = nib.instantiate(withOwner: self)[0] as! UIView
        return view
    }
    
    
    func setupView(with viewModel: SecondDetailViewModel) {
        configureView()
        let (lowValue,highValue) = viewModel.lowHighDedict()
        let changePrice = viewModel.rankChangeCalculate()
        let priceText = viewModel.priceTextFormat()
           // Configure UI elements with data
          
           low.text = "LOW:\(lowValue ?? "0.0")"
           high.text = "HIGH:\(highValue ?? "0.0")"
           changeRate.text = "\(viewModel.coin?.rank ?? 0) % (\(changePrice ?? "0.0"))"
        price.text = "$\(priceText ?? "0.00")"
      
       }
}
