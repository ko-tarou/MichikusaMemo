import SwiftUI
import MapKit

struct MapScreen: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var annotations: [MKPointAnnotation] = []
    @State private var selectedAnnotation: MKPointAnnotation? = nil
    @State private var tapBlocked = false  // タップ処理をブロックするフラグ

    var body: some View {
        ZStack {
            MapView(region: $region, annotations: $annotations, selectedAnnotation: $selectedAnnotation, tapBlocked: $tapBlocked)
                .edgesIgnoringSafeArea(.all)

            if let annotation = selectedAnnotation, annotations.contains(annotation) {
                VStack {
                    Spacer()
                    Button(action: {
                        annotations.removeAll()
                        selectedAnnotation = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var annotations: [MKPointAnnotation]
    @Binding var selectedAnnotation: MKPointAnnotation?
    @Binding var tapBlocked: Bool  // クリックをブロックするフラグ

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tapGesture)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.removeAnnotations(uiView.annotations)
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

        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            let mapView = sender.view as! MKMapView
            let location = sender.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

            if parent.tapBlocked {
                parent.tapBlocked = false
                return
            }

            parent.annotations.removeAll() // **ピンを削除してから新しいピンを追加**

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "新しいピン"
            parent.annotations.append(annotation)
            parent.selectedAnnotation = nil
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? MKPointAnnotation {
                parent.tapBlocked = true
                parent.selectedAnnotation = annotation
            }
        }

        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            parent.selectedAnnotation = nil
        }
    }
}

#Preview {
    MapScreen()
}
