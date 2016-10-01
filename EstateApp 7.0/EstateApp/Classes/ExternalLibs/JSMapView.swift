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
    func mapViewSelectedLocation(coordinate: CLLocationCoordinate2D, city: String, country:String);
}


class JSMapView: MKMapView, MKMapViewDelegate{

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
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(JSMapView.addCustomAnnotation(_:)))
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
    
    private func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Int, animated: Bool){
        let span = MKCoordinateSpanMake(0, 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        setRegion(MKCoordinateRegionMake(centerCoordinate, span), animated: animated)
    }
    
    func addCustomAnnotation(gestureRecognizer:UIGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(self)
            let newCoordinates = self.convertPoint(touchPoint, toCoordinateFromView: self)
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
                    
                    print(addressDictionary);
                    
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

// not all places have thoroughfare & subThoroughfare so validate those values
                    annotation.title = "Property Location"//pm.thoroughfare! + ", " + pm.subThoroughfare!
//                    annotation.subtitle = pm.subLocality
                    self.addAnnotation(annotation)
                
                
                self.centerCoordinate = annotation.coordinate;
                
                self.showAnnotations(self.annotations, animated: true);

                self.delegated!.mapViewSelectedLocation(self.centerCoordinate, city: city, country:country);
                
            })
        }
    }

    func addNewPinsFromList(properties: [Property]) -> Void{
        
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
            dropPin.coordinate = CLLocationCoordinate2D(latitude: Double(property.latitude!)!, longitude: Double(property.longitude!)!);
            dropPin.title = property.titleMsg! as String;
            dropPin.subtitle = title;
            dropPin.imageName = "pickup_pin";// "pickup_pin" / "dropOff_pin"
            
            self.addAnnotation(dropPin);

            self.centerCoordinate = dropPin.coordinate;
        }
    }

    
    func addNewPin(property: Property) -> CustomPointAnnotation{
        
        self.zoomLevel = 10;
        
        self.removeAnnotations(self.annotations);
        
        self.delegate = self
        self.showsUserLocation = false;
        // Drop a pin
        let dropPin = CustomPointAnnotation();
        dropPin.coordinate = CLLocationCoordinate2D(latitude: Double(property.latitude!)!, longitude: Double(property.longitude!)!);
        dropPin.title = property.titleMsg! as String;
        dropPin.imageName = "pickup_pin";// "pickup_pin" / "dropOff_pin"
        
        self.addAnnotation(dropPin);
        
        self.centerCoordinate = dropPin.coordinate;
        
        
        let setting = Settings.loadSettings();
        

        let dropPin2 = CustomPointAnnotation();
        dropPin2.coordinate = CLLocationCoordinate2D(latitude:  Double(setting.latitude)!, longitude:  Double(setting.latitude)!);
        dropPin2.title = "Your Locaiton";
        dropPin2.imageName =  "dropOff_pin";
        
        self.addAnnotation(dropPin2);

        
        self.showRouteForPoints(dropPin2.coordinate, point2: dropPin.coordinate)
        
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
        directionsRequest.transportType = MKDirectionsTransportType.Automobile
        let directions = MKDirections(request: directionsRequest)
        directions.calculateDirectionsWithCompletionHandler({ (response, error) -> Void in
            
            if error == nil {
                self.myRoute = response!.routes[0] as? MKRoute
                self.addOverlay((self.myRoute?.polyline)!)
            }
        })
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "customPin"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
            anView!.draggable = true
            if ( mapView.tag == 100 ) {
                anView!.draggable = false
            }
        }
        else {
            anView!.annotation = annotation
        }
        
        let customPin = annotation as! CustomPointAnnotation
        anView!.image = UIImage(named:customPin.imageName)
        
        return anView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if (newState == MKAnnotationViewDragState.Starting) {
            view.dragState = MKAnnotationViewDragState.Dragging
        } else if (newState == MKAnnotationViewDragState.Ending || newState == MKAnnotationViewDragState.Canceling){
            view.dragState = MKAnnotationViewDragState.None
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let lineRenderer = MKPolylineRenderer(polyline: (myRoute?.polyline)!)
        lineRenderer.strokeColor = UIColor.blueColor(); //
        lineRenderer.lineWidth = 10.0
        return lineRenderer;
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        
        print("zoom level " + String(self.zoomLevel));
        print("get Radius " + String(getRadius()));
    }
    
    func getRadius() -> CLLocationDistance {
        
        
        let centerCoor = self.getCenterCoordinate();

        //    // init center location from center coordinate
        let centerLocation = CLLocation(latitude: centerCoor.latitude, longitude: centerCoor.longitude)
            
        let topCenterCoor = self.getTopCenterCoordinate();
        
        let topCenterLocation = CLLocation(latitude: topCenterCoor.latitude, longitude: topCenterCoor.longitude)

        let radius = centerLocation.distanceFromLocation(topCenterLocation);
            
        return ((radius)/1000.0)/2.0;
    }
    
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        
        return self.centerCoordinate;
    }
    
    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        
        
        let size = self.frame.size.width / 2.0;
        return self.convertPoint(CGPointMake(size, 0.0), toCoordinateFromView: self)
    }
    
    
    
    
//    - (CLLocationDistance)getRadius
//    {
//    CLLocationCoordinate2D centerCoor = [self getCenterCoordinate];
//    // init center location from center coordinate
//    CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerCoor.latitude longitude:centerCoor.longitude];
//    CLLocationCoordinate2D topCenterCoor = [self getTopCenterCoordinate];
//    CLLocation *topCenterLocation = [[CLLocation alloc] initWithLatitude:topCenterCoor.latitude longitude:topCenterCoor.longitude];
//    CLLocationDistance radius = [centerLocation distanceFromLocation:topCenterCoor];
//    return radius;
//    }
//    It will return the radius in metres.
//    To get center coordinate
//    - (CLLocationCoordinate2D)getCenterCoordinate
//    {
//    CLLocationCoordinate2D centerCoor = [self.mapView centerCoordinate];
//    return centerCoor;
//    }
//    For getting radius, depends on where you want to get the 2nd point. Lets take the Top Center
//    - (CLLocationCoordinate2D)getTopCenterCoordinate
//    {
//    // to get coordinate from CGPoint of your map
//    CLLocationCoordinate2D topCenterCoor = [self.mapView convertPoint:CGPointMake(self.mapView.frame.size.width / 2.0f, 0) toCoordinateFromView:self.mapView];
//    return topCenterCoor;
//    }

}

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

