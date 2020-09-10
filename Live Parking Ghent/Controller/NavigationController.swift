import UIKit

class ParkingNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor(named: "AccentDark")
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "AccentDark")
        self.navigationController?.navigationBar.isTranslucent = false

    }

}
