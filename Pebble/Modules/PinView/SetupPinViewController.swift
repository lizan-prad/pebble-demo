//
//  SetupPinViewController.swift
//  EtherWallet
//
//  Created by Macbook Pro on 20/05/2022.
//

import UIKit
import SVPinView


class SetupPinViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var pinTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var pinDesc: UILabel!
    
    var didDismiss: (() -> ())?
    var didSetPin: ((String) -> ())?
    
    var state: String?
    var amount: [String] = [] {
        didSet {
            self.pinView.pastePin(pin: amount.joined())
        }
    }
    
    enum PinMode {
        case set
        case verify
    }
    
    
    var defaultMode: PinMode = .set
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        pinView.style = .none
     
        self.pinDesc.text = defaultMode == .set ? "Create your PIN code to enter the app" : "Enter your current PIN code"
        
    }
    
    func setupTheme() {
        let currentTheme = ThemeManager.currentTheme(currentTheme)
        self.collectionView.backgroundColor = currentTheme.backgroundColor
        self.view.backgroundColor = currentTheme.backgroundColor
        self.pinTitle.textColor = currentTheme.mainTextColor
        self.pinView.textColor = currentTheme.mainTextColor!
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "BackSpaceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BackSpaceCollectionViewCell")
        collectionView.register(UINib.init(nibName: "NumberCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NumberCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setupTheme()
    }
    
}

extension SetupPinViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StringConstants.numbers.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        if indexPath.row == 11 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackSpaceCollectionViewCell", for: indexPath) as! BackSpaceCollectionViewCell
            cell.setup()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCollectionViewCell", for: indexPath) as! NumberCollectionViewCell
        cell.numberlabel.text = StringConstants.numbers[indexPath.row]
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 9 {
            return
        }
        
     
            if indexPath.row == 11 {
                if amount.count != 0 {
                    amount.removeLast()
                    self.pinView.clearPin {
                        self.pinView.pastePin(pin: self.amount.joined())
                    }
                       
                    
                    
                }
            } else {
                
                amount.append(StringConstants.numbers[indexPath.row])
                
                if amount.count == 4 {
                   
                    if self.defaultMode == .set {
                        
                        //                mainAcc = acc
                        self.dismiss(animated: true) {
                            self.dismiss(animated: true) {
                                self.didSetPin?(self.amount.joined())
                            }
                        }
                    } else {
//                        guard let pin = UserDefaults.standard.string(forKey: "PIN"), pin == amount.joined() else {
//                            self.pinView.clearPin()
//                            self.amount = []
//                            self.showToastMsg("Incorrect PIN", state: .error, location: .bottom)
//                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//                                self.dismiss(animated: true)
//                            }
//                            return}
                        if self.state == "REMOVE" {
                            self.dismiss(animated: true) {
                                UserDefaults.standard.set(nil, forKey: "PIN")
                                self.didDismiss?()
                            }
                        } else if state == nil {
                            let vc = UIStoryboard.init(name: "BaseTabbar", bundle: nil).instantiateViewController(withIdentifier: "BaseTabbarViewController") as! BaseTabbarViewController
                            appdelegate.window?.rootViewController = vc
                        } else if state == "V" {
                            self.dismiss(animated: true) {
                                self.didSetPin?(self.amount.joined())
                            }
                        }
                        
                    }
                }
            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width/3 - 60, height: 80)
    }
}

