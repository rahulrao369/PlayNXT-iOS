//
//  OnboardingVc.swift
//  Playnxt
//
//  Created by CP on 16/09/22.
//

import UIKit

class OnboardingVc: UIViewController {

    //MARK: - Iboutlets
   
    @IBOutlet weak var collOnboardingData: UICollectionView!
    @IBOutlet weak var btnChange: RoundButton!
    
    //MARK: - Variable
    
    var currentIndex = Int()
    
    let arrData : [AllData] = [AllData(name: "Your premium video game backlog manager.", header: "Welcome to Playnxt", img: "dash1"),AllData(name: "Ever finish a game and can’t decide which one to play next? Just tap the Playnxt button and let us decide for you.Use the Playnxt button to add games to your backlog or help choose what game to play next.", header: "Playnxt Button", img: "dash2"),AllData(name: "Keep track of all your video games across platforms in one convenient location–your back pocket.", header: "Manage Backlog", img: "dash3"),AllData(name: "See the backlog activity of the Playnxt community and the friends you follow.", header: "Community/Friend Activity", img: "dash4"),AllData(name: "Get the full premium experience with the ability to message friends, access Wishlists, use a custom calendar tool, and see personalized backlog stats.", header: "Playnxt Premium", img: "dash5")]
    
    
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        currentIndex = 0
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
       
        currentIndex = currentIndex + 1
        
        if sender.currentTitle == "Get Start" {
            let vc = storyboard!.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if currentIndex == 4 {
            btnChange.setTitle("Get Start", for: .normal)
           
            let rect = self.collOnboardingData.layoutAttributesForItem(at:IndexPath(row: currentIndex, section: 0))?.frame
            if(rect != nil)
            {
                self.collOnboardingData.scrollRectToVisible(rect!, animated: true)
            }
            
        }else {
            print("CurrentIndexButtton--------",currentIndex)
           // self.collOnboardingData.scrollToItem(at:IndexPath(item: currentIndex, section: 0), at: .right, animated: false)
            
            let rect = self.collOnboardingData.layoutAttributesForItem(at:IndexPath(row: currentIndex, section: 0))?.frame
            if(rect != nil)
            {
                self.collOnboardingData.scrollRectToVisible(rect!, animated: true)
            }
            
            btnChange.setTitle("Next", for: .normal)
        }
    }
    
   
}

//MARK: - Extension

extension OnboardingVc : UICollectionViewDelegate,UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collOnboardingData.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OnboardCell
        let data = arrData[indexPath.row]
        cell.lblHeader.text = data.header
        cell.lblDetail.text = data.name
        cell.imgScroll.image = UIImage.init(named: data.image)
        return cell
    }
    
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           var visibleRect = CGRect()
           visibleRect.origin = collOnboardingData.contentOffset
           visibleRect.size = collOnboardingData.bounds.size
           let visiblePoint = CGPoint(x: CGFloat(visibleRect.midX), y: CGFloat(visibleRect.midY))
           let visibleIndexPath: IndexPath? = collOnboardingData.indexPathForItem(at: visiblePoint)
        currentIndex = visibleIndexPath?.row ?? 0
        print("CurrentIndex--------",currentIndex)
        if currentIndex == 4 {
            btnChange.setTitle("Get Start", for: .normal)
        }else {
           
            btnChange.setTitle("Next", for: .normal)
        }
       }

}

//MARK: - Extension

extension OnboardingVc:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth =  collectionView.frame.size.width
        return CGSize(width: collectionWidth/1, height: 335)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
}

// MARK: - Collection Class

class OnboardCell : UICollectionViewCell {
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var imgScroll: UIImageView!
}


// MARK: -  Structure

struct AllData {
    
    var name : String
    var header : String
    var image : String
    
    
    init (name:String,header:String,img:String)
    {
        
        self.name = name
        self.image = img
        self.header = header
    }
}
