import UIKit
import FBSDKLoginKit
import Alamofire

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBAction func afterlog(_sender: AnyObject){
        performSegue(withIdentifier: "afterlog", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        
        
        // Set URL for endpoint
        let todoEndpoint: String = "http://remind-dbc.herokuapp.com/lists"
        
        /*
         // Standard GET request and parsed JSON object can be manipulated after it comes back from server
         Alamofire.request(todoEndpoint, method: .get)
         .responseJSON { response in
         // handle JSON here
         guard let json = response.result.value as? [String: Any] else {
         print("Didn't get list object as JSON from API")
         print("Error: \(response.result.error)")
         return
         }
         print(json)
         }
         
         */
        
        // POST request
        
        let newList: [String: Any] = ["name": "Test API List", "user_id" : 1]
        Alamofire.request(todoEndpoint, method: .post, parameters: ["list": newList], encoding: JSONEncoding.default)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on /lists")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get list object as JSON from API")
                    print("Error: \(response.result.error)")
                    return
                }
                guard let listName = json["name"] as? String else {
                    print("Could not get list name from JSON")
                    return
                }
                print("The title is: " + listName)
                
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Yakakaaaa")
            return
        }
        
        if((FBSDKAccessToken.current()) != nil){
            var cool = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, id, name, first_name, last_name"]).start(completionHandler: { (connection, result, error) -> Void in print(result)})
        }
        print(FBSDKAccessToken.current().userID)
        print("logged_in")
        afterlog(_sender: self)
        var userId = FBSDKAccessToken.current().userID
        var userRoute = "http://remind-dbc.herokuapp.com/users"
        Alamofire.request(userRoute, method: .post, parameters: ["facebook_id": userId], encoding: JSONEncoding.default)
            .responseJSON { response in
                
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on /lists")
                    print(response.result.error!)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.result.value as? [String: Any] else {
                    print("didn't get list object as JSON from API")
                    print("Error: \(response.result.error)")
                    return
                }
                guard let listName = json["name"] as? String else {
                    print("Could not get list name from JSON")
                    return
                }
                print("The title is: " + listName)
                
        }
        
    }
    
    
    
}
