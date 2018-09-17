import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let carViewController = CarViewController()
        carViewController.vm = CarViewModel()
        self.window?.rootViewController = carViewController
        self.window?.makeKeyAndVisible()
        return true
    }
}
