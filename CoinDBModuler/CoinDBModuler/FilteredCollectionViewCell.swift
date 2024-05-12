//
//  FilteredCollectionViewCell.swift
//  CoinDBModuler
//
//  Created by Ece Ok, Vodafone on 12.05.2024.
//

import UIKit

class FilteredCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var filterButton: UIButton!
    var applyFilterAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        filterButton.addTarget(self, action: #selector(applyFilterButtonTapped), for: .touchUpInside)
        // Initialization code
    }
    
    func configure( filterType : String){
        filterButton.setTitle("\(filterType)".replacingOccurrences(of: ".", with: ""), for: .normal)
        
    }
    @objc private func applyFilterButtonTapped() {
           applyFilterAction?()
       }
    
}
