//
//  JSMapView.swift
//  Velodrome
//
//  Created by JayD on 31/01/2016.
//  Copyright © 2016 Junaid iOS. All rights reserved.
//

import UIKit
import MapKit


protocol JSMapViewDelegate: class {
    
    /// Media Launched successfully on the cast device
    func mapViewSelectedLocation(_ coordinate: CLLocationCoordinate2D, city: String, country:String);
    
    
    func mapViewAnnonationTap(_ property: Property);
}


class JSMapView: MKMapView, MKMapViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    var myRoute : MKRoute?;
    weak var delegated: JSMapViewDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.showsUserLocation = false;
        self.delegate = self;
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addCustomAnnotation(_:)))
        longPressGesture.minimumPressDuration = 1.0
        self.addGestureRecognizer(longPressGesture)
    }
    
    var zoomLevel: Int {
        get {
            return Int(log2(360 * (Double(self.frame.size.width/256) / self.region.span.longitudeDelta)) + 1);
        }
        
        set (newZoomLevel){
            setCenterCoordinate(self.centerCoordinate, zoomLevel: newZoomLevel, animated: false)
        }
    }
    
    private func setCenterCoordinate(_ coordinate: CLLocationCoordinate2D, zoomLevel: Int, animated: Bool){
        let span = MKCoordinateSpanMake(0, 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        setRegion(MKCoordinateRegionMake(centerCoordinate, span), animated: animated)
    }
    
    func addPinOnGetCityAndCountry(_ newCoordinates: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        
        self.removeAnnotations(self.annotations);
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            var city = "";
            var country = "";
            
            if placemarks!.count > 0 {
                let placemark   = placemarks![0]
                let addressDictionary = placemark.addressDictionary
                
                print(addressDictionary ?? "nil");
                
                if let citytemp = addressDictionary!["City"] {
                    
                    city = citytemp as! String;
                }
                
                if city == "" {
                    
                    if let citytemp = addressDictionary!["FormattedAddressLines"] {
                        
                        let citytempArr = citytemp as! NSArray;
                        city = citytempArr[0] as! String;
                    }
                }
                
                if let countryTemp = addressDictionary!["Country"]{
                    
                    country = countryTemp as! String;
                }
            }
            
            annotation.title = "Property Location"
            self.addAnnotation(annotation)
            
            self.centerCoordinate = annotation.coordinate;
            self.showAnnotations(self.annotations, animated: true);
            self.delegated?.mapViewSelectedLocation(self.centerCoordinate, city: city, country:country);
            
        })
    }
    
    @objc func addCustomAnnotation(_ gestureRecognizer:UIGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = gestureRecognizer.location(in: self)
            let newCoordinates = self.convert(touchPoint, toCoordinateFrom: self)
            self.addPinOnGetCityAndCountry(newCoordinates)
        }
    }

    func addNewPinsFromList(_ properties: [Property]) -> Void{
        
        self.removeAnnotations(self.annotations);
        
        self.delegate = self;
        self.showsUserLocation = false;
        // Drop a pin
        
        for property in properties {
        
            var title = "";
          
            if property.distance.length > 0 {
                title = property.distance;
            }
            if title.length == 0 {
                title = property.duration + " away";
            }
            else  {
                    title =  title + ", \(property.duration) away";
            }

            let dropPin = CustomPointAnnotation();
            dropPin.coordinate = CLLocationCoordinate2D(latitude: Double(property.latitude)!, longitude: Double(property.longitude)!);
            dropPin.title = property.titleMsg;
            dropPin.subtitle = title;
            dropPin.imageName = "pickup_pin";// "pickup_pin" / "dropOff_pin"
            dropPin.data = property;
            self.addAnnotation(dropPin);

            self.centerCoordinate = dropPin.coordinate;
        }
    }

    
    func addUserPin() -> CLLocationCoordinate2D {
        
        self.delegate = self
        self.showsUserLocation = false;
        
        let setting = Settings.loadSettings();
        
        let dropPin2 = CustomPointAnnotation();
        dropPin2.coordinate = CLLocationCoordinate2D(latitude:  Double(setting.latitude)!, longitude:  Double(setting.longitude)!);
        dropPin2.title = "Your Locaiton";
        dropPin2.imageName =  "dropOff_pin";
        
        self.addAnnotation(dropPin2);
        
        return dropPin2.coordinate;
    }
    
    func addShowRoutePin(property: Property) -> CustomPointAnnotation{
        
        self.zoomLevel = 10;
        
        self.removeAnnotations(self.annotations);
        
        self.delegate = self
        self.showsUserLocation = false;
        // Drop a pin
        let dropPin = CustomPointAnnotation();
        dropPin.coordinate = CLLocationCoordinate2D(latitude: Double(property.latitude)!, longitude: Double(property.longitude)!);
        dropPin.title = property.titleMsg;
        dropPin.imageName = "pickup_pin";// "pickup_pin" / "dropOff_pin"
        dropPin.data = property;

        self.addAnnotation(dropPin);
        
        self.centerCoordinate = dropPin.coordinate;
        
        let setting = Settings.loadSettings();
        
        let dropPin2 = CustomPointAnnotation();
        dropPin2.coordinate = CLLocationCoordinate2D(latitude:  Double(setting.latitude)!, longitude:  Double(setting.longitude)!);
        dropPin2.title = "Your Locaiton";
        dropPin2.imageName =  "dropOff_pin";

        self.addAnnotation(dropPin2);

        
        self.showRouteForPoints(point1: dropPin2.coordinate, point2: dropPin.coordinate)
        
//        self.showAnnotations(self.annotations, animated: true);

        // Test Custom Pin Location with Apple Default pin
/*
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.addAnnotation(annotation)
*/
        return dropPin;
    }
    
    func addTwoPins(title1:String, imageName1:String, location1:CLLocationCoordinate2D
        , title2:String, imageName2:String, location2:CLLocationCoordinate2D){
            
            self.removeAnnotations(self.annotations);
            
            self.delegate = self;
            self.showsUserLocation = false;
            // Drop a pin
            let dropPin1 = CustomPointAnnotation();
            dropPin1.coordinate = location1;
            dropPin1.title = title1 as String;
            dropPin1.imageName = imageName1;
            
            self.addAnnotation(dropPin1);
            
            let dropPin2 = CustomPointAnnotation();
            dropPin2.coordinate = location2;
            dropPin2.title = title2 as String;
            dropPin2.imageName = imageName2;
            
            self.addAnnotation(dropPin2);
            
            self.showAnnotations(self.annotations, animated: true);
    }
    
    
    func showRouteForPoints(point1: CLLocationCoordinate2D, point2:CLLocationCoordinate2D){
       
        self.removeOverlays(self.overlays);
//        self.setRegion(MKCoordinateRegionMake(point2, MKCoordinateSpanMake(0.7,0.7)), animated: true)
        
        let directionsRequest = MKDirectionsRequest();
        
        let markPickUp = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.latitude, point1.longitude), addressDictionary: nil)
        
        let markDropOff = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.latitude, point2.longitude), addressDictionary: nil)
        
        directionsRequest.source = MKMapItem(placemark: markPickUp)
        directionsRequest.destination = MKMapItem(placemark: markDropOff)
        directionsRequest.transportType = MKDirectionsTransportType.automobile
        let directions = MKDirections(request: directionsRequest)
        directions.calculate(completionHandler: { (response, error) -> Void in
            
            if error == nil {
                self.myRoute = response!.routes[0] as? MKRoute
                self.add((self.myRoute?.polyline)!)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "customPin"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
            anView!.isDraggable = true
            if ( mapView.tag == 100 ) {
                anView!.isDraggable = false
            }
        }
        else {
            anView!.annotation = annotation
        }
        
        let customPin = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:customPin.imageName)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        let image : UIImage = UIImage(named:"ic_black")!.withRenderingMode(.alwaysTemplate)

        button.setImage(image, for: .normal)

        button.tintColor = UIColor.lightGray
        
        anView!.rightCalloutAccessoryView = button
        
        return anView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if let pinView = view.annotation as? CustomPointAnnotation {
            if let property  = pinView.data {
                
                self.delegated?.mapViewAnnonationTap(property);
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if (newState == MKAnnotationViewDragState.starting) {
            view.dragState = MKAnnotationViewDragState.dragging
        } else if (newState == MKAnnotationViewDragState.ending || newState == MKAnnotationViewDragState.canceling){
            view.dragState = MKAnnotationViewDragState.none
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let lineRenderer = MKPolylineRenderer(polyline: (myRoute?.polyline)!)
        lineRenderer.strokeColor = UIColor.appTheme; //
        lineRenderer.lineWidth = 5.0
        return lineRenderer;
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        
        print("zoom level " + String(self.zoomLevel));
        print("get Radius " + String(getRadius()));
    }
    
    func getRadius() -> CLLocationDistance {
        
        
        let centerCoor = self.getCenterCoordinate();

        //    // init center location from center coordinate
        let centerLocation = CLLocation(latitude: centerCoor.latitude, longitude: centerCoor.longitude)
            
        let topCenterCoor = self.getTopCenterCoordinate();
        
        let topCenterLocation = CLLocation(latitude: topCenterCoor.latitude, longitude: topCenterCoor.longitude)

        let radius = centerLocation.distance(from: topCenterLocation);
            
        return ((radius)/1000.0)/2.0;
    }
    
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        
        return self.centerCoordinate;
    }
    
    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        
        let size = self.frame.size.width / 2.0;
        let points = CGPoint(x:size, y:0.0);
        return self.convert(points, toCoordinateFrom: self)
    }
}

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
    var data: Property!
}

