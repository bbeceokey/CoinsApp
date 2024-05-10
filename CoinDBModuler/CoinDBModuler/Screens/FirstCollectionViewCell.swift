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
    
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var coinIconImage: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var change: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
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
        price.text = "$\(formatPrice(model.price!))"
        change.text = "$\(setIcon(model)) \(model.change)% ($\(setIcon(model))\(calculateChangeRate(model)))"
    }
    
    func formatPrice(_ price : String) -> String{
        if let price = Double(price) {
            let roundedPrice = round(price * 1000) / 1000
            let formattedPrice = String(format: "$%.3f", roundedPrice)
            return formattedPrice
        } else {
    
            return ("format error")
        }
        
    }
    func calculateChangeRate(_ model : Coin) -> String {
        
        if let change = Double(model.change!){
            let modelPrice = Double(model.price!)
            let changeRange = modelPrice! * change / 100
            if changeRange > 0 {
                let lastPrice = modelPrice! + changeRange
                return String(lastPrice)
            } else {
                let lastPrice = modelPrice! - changeRange
                return formatPrice(String(lastPrice))
            }
        } else {
            return "error"
        }
        
    }
    
    func setIcon(_ model : Coin) -> String {
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
