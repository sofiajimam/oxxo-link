//
//  CircularMapView.swift
//  Leclerc
//
//  Created by Sofía Jimémez Martínez on 24/04/24.
//

import SwiftUI
import MapKit

class CircularMapView: MKMapView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }

    private func setupView() {
        let circlePath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.path = circlePath.cgPath
        layer.mask = maskLayer

        // Enable showing user's location
        showsUserLocation = true
    }
}

#Preview {
    CircularMapView()
}


#Preview {
    CircularMapView()
}
