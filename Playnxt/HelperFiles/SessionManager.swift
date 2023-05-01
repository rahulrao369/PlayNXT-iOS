import UIKit
import Alamofire


class SessionManager: NSObject {

    static var shared = SessionManager()

    var createWallet: Bool = true

    func methodForApiCalling<T: Codable>(url: String, method: HTTPMethod, parameter: Parameters?, objectClass: T.Type, requestCode: String, userToken: String?, completionHandler: @escaping (T) -> Void) {
        print("URL: \(url)")
        print("METHOD: \(method)")
        print("PARAMETERS: \(String(describing: parameter))")
        print("TOKEN: \(getHeader(reqCode: requestCode, userToken: userToken))")
        
        if !Connectivity.isConnectedToInternet {
            self.showAlert(msg: "Please check your internet connection")
               return
           }

        AF.request(url, method: method, parameters: parameter, encoding: JSONEncoding.default, headers: getHeader(reqCode: requestCode, userToken: userToken)).responseString { (dataResponse) in
          
            let statusCode = dataResponse.response?.statusCode
            print("statusCode: ",dataResponse.response?.statusCode)
            print("dataResponse: \(dataResponse)")

            switch dataResponse.result {
            case .success(_):
                let object = self.convertDataToObject(response: dataResponse.data, T.self)

                let errorObject = self.convertDataToObject(response: dataResponse.data, Register.self)
                let loginObject = self.convertDataToObject(response: dataResponse.data, T.self)

                if errorObject?.status == true && object != nil
                    //                    && (requestCode != U_VALIDATE_USER)
                {
                    completionHandler(object!)
                }
                else if errorObject?.status == false{
                
//                    Singleton.shared.showToast(text: (errorObject?.message!)!)
                    self.showAlert(msg: errorObject?.message)
                }
                else if statusCode == 401 {
//                    Router.mobileVC()
                }
                else if statusCode == 503  {
//                    Singleton.shared.showToast(text: "Server Problem")
                }
//                else {
//                    if(requestCode == U_VERIFY_NUMBER){
//                        if let object = loginObject {
//                          completionHandler(object)
//                        }else {
////                            Singleton.shared.showToast(text:  errorObject?.message ?? "")
//                        }
//                    }
            else
            {
//                      Singleton.shared.showToast(text:  errorObject?.message ?? "")
                    }

//            ActivityIndicator.hide()
//                break
            case .failure(_):
//                ActivityIndicator.hide()
//                let error = dataResponse.error?.localizedDescription
//                if error == "The Internet connection appears to be offline." {
//                    //Showing error message on alert
////                    Singleton.shared.showToast(text: error ?? "")
//                } else {
//                    //Showing error message on alert
////                    Singleton.shared.showToast(text: error ?? "")
//                }
                break
            }
        }
    }
    
    private func showAlert(msg: String?) {
        UIApplication.shared.keyWindow?.rootViewController?.showAlert(message: msg ?? "")

    }


    private func convertDataToObject<T: Codable>(response inData: Data?, _ object: T.Type) -> T? {
        if let data = inData {
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(T.self, from: data)
                return decoded
            } catch {
                print(error)
            }
        }
        return nil
    }

    func getHeader(reqCode: String, userToken: String?) -> HTTPHeaders? {
        let authToken = UserDefaults.standard.value(forKey: Constant.Token) as? String
//        if (reqCode != U_LOGIN) || (reqCode != U_SIGNUP) {
            if authToken == nil{
                return nil
            }else {
                return ["Authorization": "Bearer " + authToken!]
            }
//        }
       
    }
    
    //----------------------------------------------------------------------
    
    func methodForApiCallingJson<T: Codable>(url: String, method: HTTPMethod, parameter: Parameters?, objectClass: T.Type, requestCode: String, userToken: String?, completionHandler: @escaping (T) -> Void) {
        
        print("URL: \(url)")
        print("METHOD: \(method)")
        print("PARAMETERS: \(parameter)")
        print("TOKEN: \(getHeader(reqCode: requestCode, userToken: userToken))")
        
        if !Connectivity.isConnectedToInternet {
            self.showAlert(msg: "Please check your internet connection")
               return
           }
        UIApplication.shared.keyWindow?.rootViewController?.showActivity(myView: (UIApplication.shared.keyWindow?.rootViewController?.view)!, myTitle: "Loading...")

        AF.request(url, method: method, parameters: parameter, encoding: JSONEncoding.default, headers: getHeader(reqCode: requestCode, userToken: userToken)).responseJSON() { (dataResponse) in
            
            let statusCode = dataResponse.response?.statusCode
            UIApplication.shared.keyWindow?.rootViewController?.removeActivity(myView:  (UIApplication.shared.keyWindow?.rootViewController?.view)!)
            print("statusCode: ",dataResponse.response?.statusCode)
            print("dataResponse: \(dataResponse)")
            let checkData = dataResponse.value as! [String:Any]

            switch dataResponse.result {
            case .success(_):
                
//                if checkData["data"] == nil{
//                    let objectNew = self.convertDataToObject(response: dataResponse.data, T.self)
//                    completionHandler(objectNew ?? checkData as! T)
//                    return
//                }
                
                

                let object = self.convertDataToObject(response: dataResponse.data, T.self)
                let errorObject = self.convertDataToObject(response: dataResponse.data, CommonResponse.self)
                let loginObject = self.convertDataToObject(response: dataResponse.data, T.self)
                
                
                if errorObject?.status == true && object != nil
                    //                    && (requestCode != U_VALIDATE_USER)
                {
                    completionHandler(object!)
                    //completionHandler("Fafa" as! T )

                }
                else if errorObject?.status == false{
                
    //                    Singleton.shared.showToast(text: (errorObject?.message!)!)
                  self.showAlert(msg: errorObject?.message)
                   //completionHandler(object!)
                }
                else if errorObject?.status == nil{
                    print("checkData11111: \(errorObject?.message)")

    //                    Singleton.shared.showToast(text: (errorObject?.message!)!)
                  self.showAlert(msg: errorObject?.message)
                   //completionHandler(object!)
                }
                else if statusCode == 401 {
    //                    Router.mobileVC()
                }
                else if statusCode == 503  {
    //                    Singleton.shared.showToast(text: "Server Problem")
                }
    //                else {
    //                    if(requestCode == U_VERIFY_NUMBER){
    //                        if let object = loginObject {
    //                          completionHandler(object)
    //                        }else {
    ////                            Singleton.shared.showToast(text:  errorObject?.message ?? "")
    //                        }
    //                    }
            else
            {
    //                      Singleton.shared.showToast(text:  errorObject?.message ?? "")
                    }

    //            ActivityIndicator.hide()
    //                break
            case .failure(_):
                
                print("checkData11111: \(checkData)")
    //                ActivityIndicator.hide()
    //                let error = dataResponse.error?.localizedDescription
    //                if error == "The Internet connection appears to be offline." {
    //                    //Showing error message on alert
    ////                    Singleton.shared.showToast(text: error ?? "")
    //                } else {
    //                    //Showing error message on alert
    ////                    Singleton.shared.showToast(text: error ?? "")
    //                }
                self.showAlert(msg: checkData["message"] as! String)
                break
            }
        }
    }

}
//MARK: -
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}



