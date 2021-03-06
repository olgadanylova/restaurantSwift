
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var enterTheAppButton: UIButton!
    
    private let APPLICATION_ID = "37DA4B50-6A41-A157-FF0D-474B488B2300"
    private let API_KEY = "8F51D5C8-18FB-1862-FFD6-1E0ED9A77700"
    private let SERVER_URL = "https://api.backendless.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Backendless.sharedInstance().hostURL = SERVER_URL
        Backendless.sharedInstance().initApp(APPLICATION_ID, apiKey: API_KEY)
        view.bringSubviewToFront(enterTheAppButton)
        enterTheAppButton.layer.cornerRadius = 20
        enterTheAppButton.layer.masksToBounds = true
    }
    
    @IBAction func unwindToLoginVC(segue:UIStoryboardSegue) {
    }   
    
    @IBAction func pressedEnterTheApp(_ sender: Any) {
        performSegue(withIdentifier: "ShowRestaurant", sender: sender)
    }
}
