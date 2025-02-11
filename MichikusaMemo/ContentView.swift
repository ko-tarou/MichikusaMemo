import SwiftUI
import MapKit

struct ContentView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6812, longitude: 139.7671), // 東京駅
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var pins: [Pin] = []
    @State private var showTextField = false
    @State private var newPinTitle = ""
    @State private var newPinCoordinate: CLLocationCoordinate2D?

    var body: some View {
        ZStack {
            MapView(region: $region, pins: $pins, onAddPin: { coordinate in
                self.newPinCoordinate = coordinate
                self.showTextField = true
            })
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            loadPins()
        }
        .sheet(isPresented: $showTextField) {
            VStack {
                TextField("ピンのタイトルを入力", text: $newPinTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("追加") {
                    if let coordinate = newPinCoordinate {
                        let newPin = Pin(coordinate: coordinate, title: newPinTitle)
                        pins.append(newPin)
                        savePins()
                        newPinTitle = ""
                    }
                    showTextField = false
                }
            }
            .padding()
        }
    }
    
    func savePins() {
        if let encoded = try? JSONEncoder().encode(pins) {
            UserDefaults.standard.set(encoded, forKey: "savedPins")
        }
    }

    func loadPins() {
        if let savedData = UserDefaults.standard.data(forKey: "savedPins"),
           let decoded = try? JSONDecoder().decode([Pin].self, from: savedData) {
            pins = decoded
        }
    }
}

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var pins: [Pin]
    var onAddPin: (CLLocationCoordinate2D) -> Void
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(region, animated: false)
        mapView.delegate = context.coordinator
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.mapTapped(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        let annotations = pins.map { pin in
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            annotation.title = pin.title
            return annotation
        }
        uiView.addAnnotations(annotations)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        @objc func mapTapped(_ gesture: UITapGestureRecognizer) {
            let mapView = gesture.view as! MKMapView
            let tapPoint = gesture.location(in: mapView)
            let coordinate = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            
            DispatchQueue.main.async {
                self.parent.onAddPin(coordinate)
            }
        }
    }
}

struct Pin: Identifiable, Codable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let title: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension Pin {
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.title = title
    }
}

