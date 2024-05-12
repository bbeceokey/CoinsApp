//
//  FirstCollectionViewCell.swift
//  CoinDBModuler
//
//  Created by Ece Ok, Vodafone on 10.05.2024.
//

import UIKit
import CoinAPI
import Kingfisher

class FirstCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var calculateChange: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var coinIconImage: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var change: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.backgroundColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        layer.cornerRadius = 2.0
        layer.borderWidth = 0.25
        layer.borderColor = UIColor.orange.cgColor
        // Initialization code
    }
    override func prepareForReuse() {
           super.prepareForReuse()
           // Imageview'e nil atayarak hücre tekrar kullanıma hazırlandığında önceki içeriği temizle
           coinIconImage.image = nil
       }
    
    func configure (_ model : Coin ){
        if let iconUrl = model.iconUrl {
            let pngUrlString = iconUrl.absoluteString.replacingSVGWithPNG()
            if let pngUrl = URL(string: pngUrlString) {
                coinIconImage.kf.setImage(with: pngUrl, completionHandler: { result in
                    switch result {
                    case .success(let value):
                        print("Resim yükleme başarılı: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Resim yükleme hatası: \(error.localizedDescription)")
                    }
                })
            }
        }

        symbol.text = model.symbol
        coinName.text = model.name
        price.text = "\(formatPrice(model.price!)!)"
        change.numberOfLines = 0
        if ((model.change?.contains("-") == true)){
            change.textColor = .red
            calculateChange.textColor = .red
           
        } else {
            change.textColor = .green
            calculateChange.textColor = .green
        }
        change.text = "\(model.change!)% "
        calculateChange.text = " (\(setIcon(model)!)\(calculateChangeRate(model)!))"
    }
    
    func formatPrice(_ price : String?) -> String? {
        if let price = price {
            var roundedPrice = round((Double(price) ?? 0.0) * 1000) / 1000
            var formattedPrice = String(format: "$%.3f", roundedPrice)
            return formattedPrice
        } else {
    
            return ("format error")
        }
        
    }
    func calculateChangeRate(_ model : Coin) -> String? {
        
        if let change = model.change{
            var modelPrice = Double(model.price!)
            var changeRange = (modelPrice ?? 0.0) * (Double(change) ?? 0.0) / 100
            if changeRange > 0 {
                var lastPrice = (modelPrice ?? 0.0) + changeRange
                return String(format: "$%.3f",lastPrice)
            } else {
                var lastPrice = (modelPrice ?? 0.0) - changeRange
                return String(format: "$%.3f",lastPrice)
            }
        } else {
            return "error"
        }
        
    }
    
    func setIcon(_ model : Coin) -> String? {
        var icon : String
        let changePrice = Double(model.change!)
        if changePrice! > 0 {
            icon = "+"
            return icon
        } else {
            icon = "-"
            return icon
        }
    }
}
