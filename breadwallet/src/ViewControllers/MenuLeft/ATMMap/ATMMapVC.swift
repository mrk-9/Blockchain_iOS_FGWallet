//
//  ATMMapVC.swift
//  FGWallet
//
//  Created by Ivan on 1/7/18.
//  Copyright © 2018 Ivan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ATMMapVC: BaseViewController {
    
    @IBOutlet weak var lblTittle: UILabel!
    
    @IBOutlet weak var lblsub1: UILabel!
    
    @IBOutlet weak var lblSub2: UILabel!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var mapView: MKMapView!
    let atmLocation:[CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 43.272709, longitude: 141.549481),
                                                CLLocationCoordinate2D(latitude: 38.435252, longitude: 140.920245),
                                                CLLocationCoordinate2D(latitude: 35.779326, longitude: 139.542881),
                                                CLLocationCoordinate2D(latitude: 35.539428, longitude: 139.497176),
                                                CLLocationCoordinate2D(latitude: 34.847636, longitude:135.311275),
                                                CLLocationCoordinate2D(latitude: 34.364564, longitude: 132.386433)]
    let center = CLLocationCoordinate2D(latitude: 37.481965, longitude: 136.577850)
    let openTimes: [String]  = ["電話番号：011-271-3660\n営業時間：10：00～24：00\n定休日：年中無休",
                                "電話番号：022−797−7068\n営業時間：19:00～24:00\n定休日：日曜日定休",
                                "店舗の詳細はこちら",
                                "店舗の詳細はこちら",
                                "電話番号：06-6226-7220\n営業時間：17：00～24：00\n定休日：月曜日",
                                "店舗の詳細はこちら"]
    let titles: [String] = ["nORBESA（ノルベサ)",
                            "手品家 仙台店",
                            "WORLD STAR CAFE",
                            "Cuba mojit 専門店",
                            "chef's kichen 白猫",
                            "Petit Colon"]
    let sub: [String] = ["5 Chome-1-1 Minami 3 Jōnishi, Chūō-ku, Sapporo-shi, Hokkaidō 060-0063, Japan",
                         "2 Chome-12-18 Kokubunchō, Aoba-ku, Sendai-shi, Miyagi-ken 980-0803, Japan",
                         "5 Chome-1-3 Roppongi, Minato-ku, Tōkyō-to 106-0032, Japan",
                         "1 Chome-8 Ishikawachō, Naka-ku, Yokohama-shi, Kanagawa-ken 231-0868, Japan",
                         "1 Chome-3-5 Shinsaibashisuji, Chūō-ku, Ōsaka-shi, Ōsaka-fu 542-0085, Japan",
                         "2-19 Hashimotochō, Naka-ku, Hiroshima-shi, Hiroshima-ken 730-0015, Japan"]
    
    let regionRadius: CLLocationDistance = 1000
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
       
        self.navigationItem.title = Klang.atm_map.localized()
        mapView.delegate = self
        for (index, _) in atmLocation.enumerated() {
            let annation = MKPointAnnotation()
            annation.coordinate = atmLocation[index]
            annation.title = " "
            
            mapView.addAnnotation(annation)
        }
        mapView.showAnnotations(mapView.annotations, animated: true)
        
    }
    
    
    
    
    func centerMapLocation() {
        mapView.setCenter(center, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

 
    
    
}
extension MKAnnotationView {
    
    func loadCustomLines(customLines: [String]) {
        let stackView = self.stackView()
        for line in customLines {
            let label = UILabel()
            label.text = line
            stackView.addArrangedSubview(label)
        }
        self.detailCalloutAccessoryView = stackView
    }
    
    
    
    private func stackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }
    

}

extension ATMMapVC: MKMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
          
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = #imageLiteral(resourceName: "if_location")
        }
        
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let annoti = view.annotation!.coordinate
        let index = atmLocation.index(where: {($0.latitude == annoti.latitude && $0.longitude == annoti.longitude)})
        lblTittle.text = titles[index!]
        lblsub1.text = openTimes[index!]
        lblSub2.text = sub[index!]
        view.detailCalloutAccessoryView = viewDetail
        
    }
    
    
    
    
    
    
    
}
