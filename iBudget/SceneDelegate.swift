//
//  SceneDelegate.swift
//  iBudget
//
//  Created by Salem Kosemani on 2023-01-15.
//

import UIKit
import CoreData
import LocalAuthentication

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func authenticateUser() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error:  &error) {
                let reason = "identify yourself !"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success,
                    authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self?.window?.rootViewController!.present(ac, animated: true)
                            
                        }else{
                            //error
                            let ac = UIAlertController(title: "Authentication failed", message: "user verification failed; please try again.", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self?.window?.rootViewController!.present(ac, animated: true)
                        }
                    }
                 
                }
                
            }
        }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
      
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
         
        if( UserDefaults().string(forKey: "fullname") != nil){
            
            
           // authenticateUser()
           
            
            let customTB = storyboard.instantiateViewController(identifier: "CustomTabBarController") as! CustomTabBarController
            window?.rootViewController = customTB
            window?.makeKeyAndVisible()
            
            
            
            
        }else{
            
            let onboardVC = storyboard.instantiateViewController(withIdentifier: "userOnboarding")
            window?.rootViewController = onboardVC
            window?.makeKeyAndVisible()
 

            
        }
      
    }
    
    func getContext()->NSManagedObjectContext{
         
        let context  = AppDelegate.sharedAppDelegate.coreDataStack.getCoreDataContext()!
        
        return context
    }
    
    func saveAll(){
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
         
        print("Saved")
        //getUserInfo()
        print("Loaded")

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
     
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        UserDefaults().set(true, forKey: "locked")

    }
    
    func setRootViewController(_ vc: UIViewController) {
         if let window = self.window {
              // if we are logging in, pass the userId
              if let _ = vc as? CustomTabBarController {
                   //customTb.usersname = userId
              }
             
                  window.rootViewController = vc
              
         }
    }

}

