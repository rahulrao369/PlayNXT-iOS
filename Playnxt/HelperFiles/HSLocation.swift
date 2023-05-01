
import UIKit
import Foundation
import SystemConfiguration
import CoreLocation
//import GooglePlaces

class CurrentLocation: NSObject, CLLocationManagerDelegate {
    //Singleton Instance
    static let sharedInstance: CurrentLocation = {
        let instance = CurrentLocation()
        // setup code
        return instance
    }()
    var locationManager:CLLocationManager! = nil
    typealias completionHanlder = (_ lat: String, _ long: String) -> Void
    var completion: completionHanlder! = nil
    
    //Functions
    func function_GetCurrentLocation(location:@escaping (String,String)->Void) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 20
            
            locationManager.startUpdatingLocation()
            self.completion =  { (lat, lng) in
                location(lat,lng)
            }
        }
    }
    //Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let isLocation = locations.first {
            print("current lat long==========m","\(isLocation.coordinate.latitude)","\(isLocation.coordinate.longitude)")
            NotificationCenter.default.post(name: NSNotification.Name("Notification"), object: "ChangeLatLong", userInfo: nil)
            completion("\(isLocation.coordinate.latitude)","\(isLocation.coordinate.longitude)")
      
            locationManager.stopUpdatingLocation()
            //locationManager.delegate = nil
           // locationManager = nil
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let isLocation = manager.location {
            completion("\(isLocation.coordinate.latitude)","\(isLocation.coordinate.longitude)")
        } else {
            completion("\(0.0)","\(0.0)")
        }
    }
    
    func function_GetAddress(post:CLLocationCoordinate2D,location:@escaping (String)->Void) {
        /*self.getAddress(location: CLLocation.init(latitude: post.latitude, longitude: post.longitude)) { (address) in
            location("\(address)")
        }*/
    }
   
    func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) -> String {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        var addressString : String = ""
        
        var addData = ""
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        let pm = placemarks! as [CLPlacemark]
                                        
                                        if pm.count > 0 {
                                            let pm = placemarks![0]
                                           
                                            if pm.subLocality != nil {
                                                addressString = addressString + pm.subLocality! + ", "
                                            }
                                            if pm.thoroughfare != nil {
                                                addressString = addressString + pm.thoroughfare! + ", "
                                            }
                                            if pm.locality != nil {
                                                addressString = addressString + pm.locality!// + ", "
                                            }
                                            /*if pm.country != nil {
                                                addressString = addressString + pm.country! + ", "
                                            }
                                            if pm.postalCode != nil {
                                                addressString = addressString + pm.postalCode! + " "
                                            }*/
                                            
                                            addData = addressString
                                            print(addressString)
                                        }
                                    })
        print("addressString1111....\(addData)")
       // locationManager.stopUpdatingLocation()
        return addressString
    }
    
    func getAddressFromLattLonn(pdblLatitude: String, pdblLongitude: String, completionHandler:@escaping (_ address:String)->Void) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon
            
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            var addressString : String = ""
            locationManager.stopUpdatingLocation()
            ceo.reverseGeocodeLocation(loc, completionHandler:
                                        {(placemarks, error) in
                                            if (error != nil)
                                            {
                                                print("reverse geodcode fail: \(error!.localizedDescription)")
                                            }
                                           // let pm = (placemarks)!
                                               let pm = placemarks! as [CLPlacemark]
                                            if pm.count > 0 {
                                                let pm = placemarks![0]
                                                
                                                if pm.subLocality != nil {
                                                    addressString = addressString + pm.subLocality! + ", "
                                                }
                                                if pm.thoroughfare != nil {
                                                    addressString = addressString + pm.thoroughfare! + ", "
                                                }
                                                if pm.locality != nil {
                                                    addressString = addressString + pm.locality! //+ ", "
                                                }
                                                /*if pm.country != nil {
                                                    addressString = addressString + pm.country! + ", "
                                                }
                                                if pm.postalCode != nil {
                                                    addressString = addressString + pm.postalCode! + " "
                                                }*/
                                                print(addressString)
                                                completionHandler(addressString)
                                                
                                            }
                                        })
            
        }
    
    
    /*func getAddress(location:CLLocation,handler: @escaping (String) -> Void) {
        
        let placesClient = GMSPlacesClient.shared()
        
        
        
        placesClient.currentPlace { (likelihoodlist, error) -> Void in
            
            if error != nil {
                print("Current Place error: \(error!.localizedDescription)")
                return
            }
            var likelihood = likelihoodlist!.likelihoods.first
            
            if likelihoodlist!.likelihoods.count > 1{
                likelihood = likelihoodlist!.likelihoods[1]
            }
            
            if let likelihood = likelihood {
                let place = likelihood.place
                let strAddress = place.formattedAddress
                // let arrayAddress = strAddress?.components(separatedBy: ",")
                // if arrayAddress?.count ?? 0 > 0{
                //self.strCity = arrayAddress?[0] ?? ""
                //self.navigationLocationLabel.text = strAddress
                
                Constant.APP_OBJ.currentLocation = strAddress!
                Constant.APP_OBJ.strTopLatitude = "\(location.coordinate.latitude)"
                Constant.APP_OBJ.strTopLongitude = "\(location.coordinate.longitude)"
                // Passing address back
                handler(strAddress!)
                //}
            }
            
            
            /*var address: String = ""
             let geoCoder = CLGeocoder()
             geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
             // Place details
             var placeMark: CLPlacemark?
             placeMark = placemarks?[0]
             // Location name
             if let locationName = placeMark?.addressDictionary?["Name"] as? String {
             address += locationName + ", "
             }
             // Street address
             if let street = placeMark?.addressDictionary?["Thoroughfare"] as? String {
             address += street + ", "
             }
             // City
             if let city = placeMark?.addressDictionary?["City"] as? String {
             address += city + ", "
             }
             // Zip code
             if let zip = placeMark?.addressDictionary?["ZIP"] as? String {
             address += zip + ", "
             }
             // Country
             if let country = placeMark?.addressDictionary?["Country"] as? String {
             address += country
             }
             // Passing address back
             handler(address)
             })*/
        }
    }*/
        
        
        
}
