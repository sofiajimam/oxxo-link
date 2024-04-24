import SwiftUI
import _MapKit_SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var selectedIndex: Int = 0

    var body: some View {
        TabView(selection: $selectedIndex){
            BoardView().tabItem {
                Label("", systemImage: "doc.richtext").foregroundStyle(.orange)
            }
                VStack {
                    MapView(coordinate: $locationManager.location, markers: $locationManager.oxxoLocations)
                        .frame(width: 365, height: 365)
                    Text("5 km")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
                .tabItem {
                    Label("", systemImage: "map.fill").foregroundStyle(.orange)
                }
            ProfileView().tabItem {
                Label("", systemImage: "person.fill").foregroundStyle(.orange)
            }
        }
        .tint(Color(red: 0.95, green: 0.60, blue: 0))
        .onAppear(perform: {
            locationManager.requestLocationPermission()
            locationManager.startMonitoringOxxoRegions()
            UITabBar.appearance().unselectedItemTintColor = .systemGray
            UITabBarItem.appearance().badgeColor = UIColor(Color(red: 0.95, green: 0.60, blue: 0))
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color(red: 0.95, green: 0.60, blue: 0))]
        })
    }
}

struct HashableCLLocationCoordinate2D: Hashable {
    var coordinate: CLLocationCoordinate2D

    init(_ coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

    static func == (lhs: HashableCLLocationCoordinate2D, rhs: HashableCLLocationCoordinate2D) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus?
    var oxxoLocations: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 25.651173, longitude: -100.287479),
        CLLocationCoordinate2D(latitude: 25.649391, longitude: -100.289416),
        CLLocationCoordinate2D(latitude: 25.650179, longitude: -100.292724),
        CLLocationCoordinate2D(latitude: 25.653780, longitude: -100.289564),
        CLLocationCoordinate2D(latitude: 25.648238, longitude: -100.285553),
        CLLocationCoordinate2D(latitude: 25.654564, longitude: -100.293063),
        //test 25.64908884702023, -100.28989807133902
        CLLocationCoordinate2D(latitude: 25.64908884702023, longitude: -100.28989807133902),
    ]
    var userInOxxoRegionSince: [HashableCLLocationCoordinate2D: Date] = [:]
    var stayDurationCheckTimer: Timer?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
    }

    func requestLocationPermission() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
    }

    func startMonitoringOxxoRegions() {
        for location in oxxoLocations {
            let region = CLCircularRegion(center: location, radius: 10.0, identifier: "OxxoRegion")
            locationManager.startMonitoring(for: region)
            locationManager.requestState(for: region)
            print("Monitoring region at \(location.latitude), \(location.longitude)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            switch state {
            case .inside:
                print("Already inside Oxxo region at \(circularRegion.center.latitude), \(circularRegion.center.longitude)")
                userInOxxoRegionSince[HashableCLLocationCoordinate2D(circularRegion.center)] = Date()
                startStayDurationCheckTimer(for: circularRegion.center)
            case .outside:
                print("Outside Oxxo region at \(circularRegion.center.latitude), \(circularRegion.center.longitude)")
                userInOxxoRegionSince[HashableCLLocationCoordinate2D(circularRegion.center)] = nil
                stopStayDurationCheckTimer()
            case .unknown:
                print("Unknown state for Oxxo region at \(circularRegion.center.latitude), \(circularRegion.center.longitude)")
            @unknown default:
                print("Unknown state for Oxxo region at \(circularRegion.center.latitude), \(circularRegion.center.longitude)")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion, region.identifier == "OxxoRegion" {
            print("Exited Oxxo region at \(Date())")
            userInOxxoRegionSince.removeValue(forKey: HashableCLLocationCoordinate2D(circularRegion.center))
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location.coordinate
            /* print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)") */
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
    }

    func checkUserStayDuration(for location: CLLocationCoordinate2D) {
        if let userInOxxoRegionSince = userInOxxoRegionSince[HashableCLLocationCoordinate2D(location)] {
            let stayDuration = Date().timeIntervalSince(userInOxxoRegionSince)
            print("User has been in Oxxo region at \(location.latitude), \(location.longitude) for \(stayDuration) seconds")
            if stayDuration > 60.0 * 1.0 { // 5 minutes
                callFunction()
            }
        }
    }

    func startStayDurationCheckTimer(for location: CLLocationCoordinate2D) {
        stayDurationCheckTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            self.checkUserStayDuration(for: location)
        }
    }

    func stopStayDurationCheckTimer() {
        stayDurationCheckTimer?.invalidate()
        stayDurationCheckTimer = nil
    }

    func callFunction() {
        // Create a Feed object
        let feed = Feed(id: "newFeed", lat: 123, lng: 123, name: "New Feed", reactions: 0)

        // Get an instance of FirestoreManager
        let firestoreManager = FirestoreManager()

        // Add the feed to Firestore
        firestoreManager.createFeed(feed: feed) { result in
            switch result {
            case .success:
                print("Feed successfully created")
            case .failure(let error):
                print("Failed to create feed: \(error)")
            }
        }
    }
}
