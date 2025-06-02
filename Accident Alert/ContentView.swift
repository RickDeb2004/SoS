//
//  ContentView.swift
//  Accident Alert
//
//  Created by Prakhar Parakh on 28/09/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var vm = ViewModal()
    
    
    var body: some View {
        
        ZStack{
            VStack{
                Map(coordinateRegion: $vm.loc,showsUserLocation: true)
                
                    .ignoresSafeArea()
                    .onAppear(){
                        vm.systemlocation()
                    }
                Text("\(vm.warning)")
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                    .font(.system(size: 40))



                
                
                
            }
            
            
        
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class ViewModal : NSObject, ObservableObject,CLLocationManagerDelegate{
    
    @Published var warning : String = ""
    @State var temp : String = ""

    var locationmanager : CLLocationManager?
    @Published var loc = MKCoordinateRegion(center:
                                                CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    func systemlocation(){
        
        if CLLocationManager.locationServicesEnabled(){
            
            locationmanager = CLLocationManager()
            locationmanager!.allowsBackgroundLocationUpdates = true
            locationmanager!.showsBackgroundLocationIndicator = true
            locationmanager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationmanager!.delegate = self
        }
        else{
            print("Location turned off")
        }
    }
    
    private func askpermision(){
        switch locationmanager?.authorizationStatus{
            
        case .notDetermined:
            locationmanager?.requestWhenInUseAuthorization()
        case .restricted:
            print("Location turned off")
        case .denied:
            print("Location turned off")

        case .authorizedAlways,.authorizedWhenInUse:
            loc = MKCoordinateRegion(center: locationmanager!.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            distance()
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        askpermision()
    }
    
    
    func distance(){
               
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            
            let user = CLLocation(latitude: locationmanager!.location!.coordinate.latitude, longitude: locationmanager!.location!.coordinate.longitude)
            let x = CLLocation(latitude: 12.820129, longitude: 80.037225)
            let d = user.distance(from: x)
            temp = "Just Checking"
            if(d<900.0){
                warning = "Slow Down"
            }
            else{
                print("The distance is ")
                print(d)
                
            }
            distance()
                
                
        }
        
    }
    
    
//    func askperm(){
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { [self] success, error in
//            if  let error = error{
//                print(error.localizedDescription)
//            }
//            else{
//                print("Success")
//                self.sen()
//
//            }
//        }
//    }
//
//    func sen(){
//
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let content = UNMutableNotificationContent()
//        content.title = "Accident Prone Area"
//        content.body = "Slow Down"
//
//        let uuidString = UUID().uuidString
//        let request = UNNotificationRequest(identifier: uuidString,
//                    content: content, trigger: trigger)
//
//        // Schedule the request with the system.
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.add(request) { (error) in
//           if error != nil {
//              print("Error")
//           }
//        }
//    }
//
    
        
    
}
