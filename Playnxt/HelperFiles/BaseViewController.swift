//
//  BaseViewController.swift
//  LegalTrot
//
//  Created by Wasim Raza on 07/08/20.
//  Copyright © 2020 Simpalm. All rights reserved.
//

import UIKit
import Foundation
import CropViewController
//import CountryList
import BSImagePicker
import PhotosUI
//import GooglePlaces
import DropDown

extension BaseViewController {
    @objc func didSelectedCountryCode(countryCode:String){}
    @objc func didSelectedImage(selectedImage:UIImage){}
    //@objc func didSelectedMultipleImages(selectedImages:[UIImage]){}
    @objc func didSelectedMultipleImages(completionHandler: ([UIImage])){}
    @objc func didSelectedLocation(address:String, withCoordinates latitude:String, longitude:String){}
    @objc func didSelectedDropDown(item:String, index:Int){}
}

class BaseViewController: UIViewController {
    
   // var countryList = CountryList()
    var isFromPhoto = false
    var isCircular: Bool?
    var shouldCropPhoto = true
    var selectedImage : UIImage?
    let imagePicker = UIImagePickerController()
    let dropDown = DropDown()
    var imgPicker = UIImage()
    
    /*
     var countries: [String] = []
     */
    
    //var delegate : BaseViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //countryList.delegate = self
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
}

//MARK:- Functions

extension BaseViewController {
    
    func selectPhoto(isCircular:Bool) {
        self.isCircular = isCircular
        let actionSheet = UIAlertController(title: "Choose any option", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {
            action in
            self.choosePhoto(isTakeAPhoto: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Select from gallery", style: .default, handler: {
            action in
            self.choosePhoto(isTakeAPhoto: false)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler:nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func choosePhoto(isTakeAPhoto:Bool)  {
        isFromPhoto = true
        imagePicker.sourceType = isTakeAPhoto ? .camera : .photoLibrary
        imagePicker.modalPresentationStyle = .currentContext
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func chooseCountryCode() {
       // let navController = UINavigationController(rootViewController: countryList)
       // self.present(navController, animated: true, completion: nil)
    }
    
    
    func selectMultiplePhoto(minCount:Int, maxCount:Int) {
        
        let imagePickerBS = ImagePickerController()
        imagePickerBS.settings.selection.max = maxCount
        imagePickerBS.settings.selection.min = minCount
        imagePickerBS.settings.theme.selectionStyle = .numbered
        imagePickerBS.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePickerBS.settings.selection.unselectOnReachingMax = false
        self.isFromPhoto = true
        presentImagePicker(imagePickerBS, select: { (asset) in
            
            
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            print("selectedAssets.count...\(assets.count)")
            
            var selectedimages = [UIImage]()
            
            /*for asset in assets {
             PHImageManager.default().requestImage(for: asset, targetSize:PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { (image, info) in
             //print("image......",image?.pngData()?.count)
             
             selectedimages.append(image!)
             
             }
             
             }
             print("selectedimages...\(selectedimages)")
             self.didSelectedMultipleImages(selectedImages: selectedimages)*/
            // User finished selection assets.
            selectedimages.removeAll()
            for asset in assets {// PHImageManagerMaximumSize //CGSize(width: 300, height: 300)
                /* PHImageManager.default().requestImage(for: asset, targetSize:PHImageManagerMaximumSize, contentMode: .aspectFit, options: option) { (image, info) in
                 //print("image......",image?.pngData()?.count)
                 /*print("selectedimagesInnerLoop...\(selectedimages)")
                  print("asset...\(asset)")
                  print("image...\(image)")*/
                 
                 if image == nil {
                 if assets.count == selectedimages.count {
                 print("selectedimages...\(selectedimages)")
                 self.didSelectedMultipleImages(completionHandler: selectedimages)
                 }
                 return
                 }
                 
                 selectedimages.append(image!)
                 
                 if assets.count == selectedimages.count {
                 print("selectedimages...\(selectedimages)")
                 self.didSelectedMultipleImages(completionHandler: selectedimages)
                 }
                 }*/
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                
                manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: option) { (result, info) in
                    
                    if result == nil {
                        if assets.count == selectedimages.count {
                            print("selectedimages nil...\(selectedimages)")
                            self.didSelectedMultipleImages(completionHandler: selectedimages)
                        }
                        return
                    }
                    self.imgPicker = result!
                }
                
                let data = self.imgPicker.jpegData(compressionQuality: 0.5)
                let newImage = UIImage(data: data!)
                selectedimages.append(newImage! as UIImage)
                
                if assets.count == selectedimages.count {
                    print("selectedimages...\(selectedimages)")
                    self.didSelectedMultipleImages(completionHandler: selectedimages)
                }
            }
        })
    }
    /*
     func selectGoogleLocation()  {
     let acController = GMSAutocompleteViewController()
     acController.placeFields = .all
     acController.delegate = self
     present(acController, animated: true, completion: nil)
     }
     */
    
    func showDropDown(view:UIView, dataSource:[String])  {
        dropDown.dataSource = dataSource
        dropDown.anchorView = view
        dropDown.bottomOffset = CGPoint(x: 0, y: view.frame.size.height)
        
        dropDown.show()
        dropDown.selectionAction = { [self] (index: Int, item: String) in
            didSelectedDropDown(item: item, index: index)
        }
    }
}

//MARK: UIImagePickerController Methods
extension BaseViewController :UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true) {
            self.isFromPhoto = false
            /*if UserModel.isLoggedIn() {
             appControllerManger.customTabBarViewController.selectedIndex = 3
             }*/
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        picker.dismiss(animated: true) {
            if self.shouldCropPhoto {
                self.isFromPhoto = true
                let cropViewController = CropViewController(croppingStyle: self.isCircular! ? .circular : .default, image: image)
                cropViewController.delegate = self
                cropViewController.modalPresentationStyle = .currentContext
                self.present(cropViewController, animated: true, completion: nil)
            }else{
                self.isFromPhoto = false
            }
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        var animation = true
        /*if UserModel.isLoggedIn() {
         animation = false
         }
         */
        selectedImage = image.resizeImage(targetSize: CGSize(width: 300, height: 300))
        
        //let imageURL = saveImageToLocal(image: selectedImage!, fileName: "ProfileImage")
        
        //NotificationCenter.default.post(name: NSNotification.Name(Constant.SELECTED_IMAGE), object: selectedImage, userInfo: nil)
        didSelectedImage(selectedImage: selectedImage!)
        //DispatchQueue.main.async {
        cropViewController.dismiss(animated: animation) {
            self.isFromPhoto = false
            /*if UserModel.isLoggedIn() {
             appControllerManger.customTabBarViewController.selectedIndex = 3
             }*/
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true) {
            self.isFromPhoto = false
            /* if UserModel.isLoggedIn() {
             appControllerManger.customTabBarViewController.selectedIndex = 3
             }*/
        }
    }
}


/*extension BaseViewController: CountryListDelegate {
    
    func selectedCountry(country: Country) {
        
        print(country.countryCode)
        print(country.phoneExtension)
        // phoneCode = "\("+")\(country.phoneExtension)"
        
        let selectedCountryCode = "\("+")\(country.phoneExtension)"
        self.didSelectedCountryCode(countryCode: selectedCountryCode)
        
    }
}*/


/*extension BaseViewController: GMSAutocompleteViewControllerDelegate {
 
 // Handle the user's selection.
 func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
 print("Place name: \(place.name)")
 print("Place address: \(place.formattedAddress)")
 print("Place attributions: \(place.attributions)")
 print("Place Coordination: \(place.coordinate)")
 
 self.didSelectedLocation(address: place.formattedAddress!, withCoordinates: String(place.coordinate.latitude), longitude: String(place.coordinate.longitude))
 dismiss(animated: true, completion: nil)
 }
 
 func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
 // TODO: handle the error.
 print("Error: \(error)")
 dismiss(animated: true, completion: nil)
 }
 
 // User cancelled the operation.
 func wasCancelled(_ viewController: GMSAutocompleteViewController) {
 print("Autocomplete was cancelled.")
 dismiss(animated: true, completion: nil)
 }
 }*/

