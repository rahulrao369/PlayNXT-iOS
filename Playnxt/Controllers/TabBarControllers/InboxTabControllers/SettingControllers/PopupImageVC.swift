//
//  PopupImageVC.swift
//  Playnxt
//
//  Created by cano on 25/05/22.
//

import UIKit

class PopupImageVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- IBOutlet
    @IBOutlet weak var imageShow: UIImageView! {
        didSet {
            let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            imageShow.addGestureRecognizer(imageTapGestureRecognizer)
            imageShow.isUserInteractionEnabled = true
        }
    }
    var image : UIImage!
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        dismiss(animated: true)
        // Do any additional setup after loading the view.
        imageShow.image = image
        removeAnimate()
    }
    
    //MARK: - Funtions
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageShow
    }
    @objc func imageTapped() {
        
        dismiss(animated: true)
    }
    @objc func viewTapped() {
        
        dismiss(animated: true)
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    //MARK:- Button Action
    
    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
