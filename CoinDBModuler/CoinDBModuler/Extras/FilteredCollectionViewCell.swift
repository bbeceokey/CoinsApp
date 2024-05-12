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
    var isSelectedCell: Bool = false {
           didSet {
               // isSelectedCell durumuna göre butonun arka plan rengini güncelle
               filterButton.backgroundColor = isSelectedCell ? .green : .clear
           }
       }
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 4.0
        
        filterButton.addTarget(self, action: #selector(applyFilterButtonTapped), for: .touchUpInside)
        // Initialization code
    }
    
    func configure( filterType : String){
        filterButton.setTitle("\(filterType)".replacingOccurrences(of: ".", with: ""), for: .normal)
        filterButton.setTitleColor(.orange, for: .normal)
        filterButton.layer.cornerRadius = 4.0
        isSelectedCell = false
        
    }
    @objc private func applyFilterButtonTapped() {
           applyFilterAction?()
           isSelectedCell.toggle()
        guard let collectionView = superview as? UICollectionView else { return }
               for case let cell as FilteredCollectionViewCell in collectionView.visibleCells {
                   if cell != self {
                       cell.isSelectedCell = false
                   }
               }
       }
    
}
