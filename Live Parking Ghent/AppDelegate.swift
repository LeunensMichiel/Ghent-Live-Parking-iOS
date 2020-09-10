import BackgroundTasks
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.leunesmedia.parkingfetch",
            using: nil) { task in
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
        return true
    }

    func handleAppRefreshTask(task: BGAppRefreshTask) {
        task.expirationHandler = {
            ParkingAPI.urlSession.invalidateAndCancel()
        }

        let fetchParkings = { (fetchedParkings: [Parking]) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "parkingFetched"), object: self, userInfo: ["parkings": fetchedParkings])
            task.setTaskCompleted(success: true)
        }

        ParkingAPI.parkingAPI.fetchParkingList(onComplete: fetchParkings)
        scheduleBackgroundFetch()
    }

    func scheduleBackgroundFetch() {
        let parkingFetchTask = BGAppRefreshTaskRequest(identifier: "com.leunesmedia.parkingfetch")
        parkingFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 900) // Every half hour
        do {
            try BGTaskScheduler.shared.submit(parkingFetchTask)
        } catch {
            print("Unable to submit background task: \(error.localizedDescription)")
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
