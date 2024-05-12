//
//  GraphView.swift
//  CoinDBModuler
//
//  Created by Ece Ok, Vodafone on 12.05.2024.
//

import UIKit
class GraphView: UIView {
    var dataPoints: [CGFloat] = [] // Koordinat verileri
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Arka planı siyah yap
        context.setFillColor(UIColor.systemGray6.cgColor)
        context.fill(rect)
        
        // Koordinat düzlemini çiz
        //drawAxes(in: context)
        
        // Veri noktalarını çiz
        drawDataPoints(in: context)
    }
    
    func drawAxes(in context: CGContext) {
        // Koordinat düzlemini çiz
        context.setStrokeColor(UIColor.magenta.cgColor) // Çizgi rengini mor yap
        context.setLineWidth(1.0)
        
        // X ekseni
        context.move(to: CGPoint(x: 50, y: bounds.height - 50))
        context.addLine(to: CGPoint(x: bounds.width - 50, y: bounds.height - 50))
        
        // Y ekseni
        context.move(to: CGPoint(x: 50, y: 50))
        context.addLine(to: CGPoint(x: 50, y: bounds.height - 50))
        
        context.strokePath()
    }
    
    func drawDataPoints(in context: CGContext) {
        guard !dataPoints.isEmpty else { return }
        
        // Veri noktalarını çiz
        let xIncrement = (bounds.width - 100) / CGFloat(dataPoints.count - 1)
        let yScale = (bounds.height - 100) / (dataPoints.max()! - dataPoints.min()!)
        
        for i in 0..<dataPoints.count {
            let x = CGFloat(i) * xIncrement + 50
            let y = bounds.height - 50 - (dataPoints[i] - dataPoints.min()!) * yScale
            
            // Noktayı çiz
            let pointRect = CGRect(x: x - 5, y: y - 5, width: 10, height: 10) // Nokta boyutunu ayarla
            context.setFillColor(UIColor.blue.cgColor) // Nokta rengini ayarla (örneğin mavi)
            context.fillEllipse(in: pointRect) // Noktayı çiz
        }
        
        // Çizgi çiz
        for i in 0..<(dataPoints.count - 1) {
            let x1 = CGFloat(i) * xIncrement + 50
            let y1 = bounds.height - 50 - (dataPoints[i] - dataPoints.min()!) * yScale
            
            let x2 = CGFloat(i + 1) * xIncrement + 50
            let y2 = bounds.height - 50 - (dataPoints[i + 1] - dataPoints.min()!) * yScale
            
            // Belirgin artışları yeşil, azalışları kırmızı yap
            let strokeColor: UIColor = dataPoints[i] < dataPoints[i + 1] ? .green : .red
            context.setStrokeColor(strokeColor.cgColor)
            
            context.setLineWidth(3.0) // Çizgi kalınlığını artır
            
            context.move(to: CGPoint(x: x1, y: y1))
            context.addLine(to: CGPoint(x: x2, y: y2))
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Önceki değer gösterme işaretleyicisini kaldır
        removePreviousValueLabel()
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        // Her bir veri noktasına dokunma konumunu kontrol et
        for i in 0..<dataPoints.count {
            let x = CGFloat(i) * ((bounds.width - 100) / CGFloat(dataPoints.count - 1)) + 50
            let y = bounds.height - 50 - (dataPoints[i] - dataPoints.min()!) * ((bounds.height - 100) / (dataPoints.max()! - dataPoints.min()!))
            
            // Dokunulan noktaya yakın bir nokta varsa, değeri göster
            let touchRect = CGRect(x: x - 15, y: y - 15, width: 30, height: 30)
            if touchRect.contains(touchLocation) {
                showDataPointValue(dataPoints[i], at: CGPoint(x: x, y: y))
                break
            }
        }
    }

    func removePreviousValueLabel() {
        // Görüntü üzerinde var olan önceki değer gösterme işaretleyicisini kaldır
        for subview in subviews {
            if let label = subview as? UILabel {
                label.removeFromSuperview()
            }
        }
    }

    
    func showDataPointValue(_ value: CGFloat, at point: CGPoint) {
     
        let valueLabel = UILabel(frame: CGRect(x: point.x, y: point.y - 20, width: 50, height: 20))
        valueLabel.textAlignment = .center
        valueLabel.textColor = UIColor.white
        valueLabel.font = UIFont.systemFont(ofSize: 12)
        valueLabel.text = "\(value)"
        addSubview(valueLabel)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 331, height: 227) // Örnek boyutlar, istediğiniz gibi değiştirilebilir
    }
}
