//
//  MapView.swift
//  Leclerc
//
//  Created by Sofía Jimémez Martínez on 24/04/24.
//

import SwiftUI
import MapKit


struct MapView: UIViewRepresentable {
    @Binding var coordinate: CLLocationCoordinate2D?
    @Binding var markers: [CLLocationCoordinate2D]

    func makeUIView(context: Context) -> CircularMapView {
        let mapView = CircularMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ uiView: CircularMapView, context: Context) {
        if let coordinate = coordinate {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), latitudinalMeters: 3000, longitudinalMeters: 3000)
            uiView.setRegion(region, animated: true)
            uiView.isUserInteractionEnabled = false

            // Add markers
            for marker in markers {
                let annotation = MKPointAnnotation()
                annotation.coordinate = marker
                uiView.addAnnotation(annotation)
                //print("Added marker at \(marker.latitude), \(marker.longitude)")
            }
        } else {
            print("Coordinate is nil")
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }

            let identifier = "Marker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                (annotationView as? MKPinAnnotationView)?.pinTintColor = .red
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: .constant(CLLocationCoordinate2D(latitude: 25, longitude: -100)), 
                markers: .constant([CLLocationCoordinate2D(latitude: 25.651173, longitude: -100.287479), 
                                         CLLocationCoordinate2D(latitude: 25.649391, longitude: -100.289416), 
                                         CLLocationCoordinate2D(latitude: 25.650179, longitude: -100.292724), 
                                         CLLocationCoordinate2D(latitude: 25.653780, longitude: -100.289564), 
                                         CLLocationCoordinate2D(latitude: 25.648238, longitude: -100.285553), 
                                         CLLocationCoordinate2D(latitude: 25.654564, longitude: -100.293063)]))
    }
}
