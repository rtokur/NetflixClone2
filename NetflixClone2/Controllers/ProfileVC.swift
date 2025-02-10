//
//  ProfileVC.swift
//  NetflixClone2
//
//  Created by Rumeysa Tokur on 8.02.2025.
//

import UIKit
import SnapKit
import FirebaseFirestore
import FirebaseAuth
import Kingfisher

// MARK: - Reload Protocol
protocol Reload {
    func reload()
}
class ProfileVC: UIViewController, ReloadData{
    // MARK: - Methods
    func didUpdateProfile() {
        viewWillAppear(true)
    }
    
    // MARK: - Properties
    var delegate: Reload?
    let db = Firestore.firestore()
    var count : Int = 0
    var profileURL: URL?
    var profileURL2: URL?
    var profileURL3: URL?
    var profileURL4: URL?
    
    // MARK: - UI Elements
    let stackView : UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 40
        return stackview
    }()
    
    let stackView2 : UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 25
        return stackview
    }()
    
    let stackView4: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor .lightGray.cgColor
        button.layer.borderWidth = 1
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(EditProfileButton), for: .touchUpInside)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tag = 1
        return button
    }()
    
    let label1: UILabel = {
        let label = UILabel()
        label.text = "Add Profile"
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    let stackView5: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    let button2: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor .lightGray.cgColor
        button.layer.borderWidth = 1
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(EditProfileButton), for: .touchUpInside)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.isHidden = true
        button.tag = 2
        return button
    }()
    
    let label2: UILabel = {
        let label = UILabel()
        label.text = "Add Profile"
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let stackView3 : UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 25
        return stackview
    }()
    
    let stackView6: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    let button3: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor .lightGray.cgColor
        button.layer.borderWidth = 1
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(EditProfileButton), for: .touchUpInside)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.isHidden = true
        button.tag = 3
        return button
    }()
    
    let label3: UILabel = {
        let label = UILabel()
        label.text = "Add Profile"
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let stackView7: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    let button4: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor .lightGray.cgColor
        button.layer.borderWidth = 1
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(EditProfileButton), for: .touchUpInside)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.isHidden = true
        button.tag = 4
        return button
    }()
    
    let label4: UILabel = {
        let label = UILabel()
        label.text = "Add Profile"
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    let navLabel: UILabel = {
        let label = UILabel()
        label.text = "Who is watching?"
        label.font = .boldSystemFont(ofSize: 19)
        label.textColor = .label
        return label
    }()


    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileData()
        setupViews()
        setupConstraints()
        navigationItem.titleView = navLabel
        navigationController?.navigationBar.isTranslucent = true
        var editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editButtonAction))
        editButton.tintColor = .label
        navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDidLoad()
    }
    // MARK: - Firebase Methods
    func getProfileData(){
        if let userId = Auth.auth().currentUser?.uid {
            Task{
                let profiles = try await db.collection("Users").document(userId).collection("Profiles").getDocuments()
                
                count = profiles.documents.count
                
                guard count != 0 else {                    
                    return
                }
                
                if let profile = profiles.documents[0].data()["profileName"] as? String, let profileUrl = profiles.documents[0].data()["profileImageURL"] as? String {
                    label1.text = profile
                    print(profileUrl)
                    profileURL = URL(string: profileUrl)
                    button.setImage(UIImage(systemName: ""), for: .normal)
                    button.kf.setBackgroundImage(with: profileURL, for: .normal)
                    button2.isHidden = false
                    label2.isHidden = false
                    if count > 1 ,let profile2 = profiles.documents[1].data()["profileName"] as? String, let profileUrl2 = profiles.documents[1].data()["profileImageURL"] as? String{
                        button3.isHidden = false
                        label3.isHidden = false
                        label2.text = profile2
                        print(profileUrl2)
                        profileURL2 = URL(string: profileUrl2)
                        button2.setImage(UIImage(systemName: ""), for: .normal)
                        button2.kf.setBackgroundImage(with: profileURL2, for: .normal)
                        if count > 2, let profile3 = profiles.documents[2].data()["profileName"] as? String, let profileUrl3 = profiles.documents[2].data()["profileImageURL"] as? String {
                            button4.isHidden = false
                            label4.isHidden = false
                            label3.text = profile3
                            print(profileUrl3)
                            profileURL3 = URL(string: profileUrl3)
                            button3.setImage(UIImage(systemName: ""), for: .normal)
                            button3.kf.setBackgroundImage(with: profileURL3, for: .normal)
                            if count > 3, let profile4 = profiles.documents[3].data()["profileName"] as? String,let profileUrl4 = profiles.documents[3].data()["profileImageURL"] as? String {
                                label4.text = profile4
                                print(profileUrl4)
                                profileURL4 = URL(string: profileUrl4)
                                button4.setImage(UIImage(systemName: ""), for: .normal)
                                button4.kf.setBackgroundImage(with: profileURL4, for: .normal)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: - Setup Methods
    func setupViews(){
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(stackView2)
        
        stackView2.addArrangedSubview(stackView4)
        
        stackView4.addArrangedSubview(button)
        
        stackView4.addArrangedSubview(label1)
        
        stackView2.addArrangedSubview(stackView5)
        
        stackView5.addArrangedSubview(button2)
        
        stackView5.addArrangedSubview(label2)
        
        stackView.addArrangedSubview(stackView3)
        
        stackView3.addArrangedSubview(stackView6)
        
        stackView6.addArrangedSubview(button3)
        
        stackView6.addArrangedSubview(label3)
        
        stackView3.addArrangedSubview(stackView7)
        
        stackView7.addArrangedSubview(button4)
        
        stackView7.addArrangedSubview(label4)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(245)
            make.height.equalTo(316)
        }
        stackView2.snp.makeConstraints { make in
            make.height.equalTo(138)
            make.width.equalToSuperview()
        }
        stackView4.snp.makeConstraints { make in
            make.width.equalTo(110)
            make.height.equalToSuperview()
        }
        button.snp.makeConstraints { make in
            make.height.equalTo(110)
        }
        label1.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        stackView5.snp.makeConstraints { make in
            make.width.equalTo(110)
            make.height.equalToSuperview()
        }
        button2.snp.makeConstraints { make in
            make.height.equalTo(110)
        }
        label2.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        stackView3.snp.makeConstraints { make in
            make.height.equalTo(138)
            make.width.equalToSuperview()
        }
        stackView6.snp.makeConstraints { make in
            make.width.equalTo(110)
            make.height.equalToSuperview()
        }
        button3.snp.makeConstraints { make in
            make.height.equalTo(110)
        }
        label3.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        stackView7.snp.makeConstraints { make in
            make.width.equalTo(110)
            make.height.equalToSuperview()
        }
        button4.snp.makeConstraints { make in
            make.height.equalTo(110)
        }
        label4.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
    }
    // MARK: - Actions
    @objc func EditProfileButton(_ sender: UIButton) {
        if sender.currentImage == UIImage(systemName: "plus") {
            let evc = EditProfileVC()
            evc.delegate = self
            evc.count = count
            present(evc, animated: true)
        }else if sender.currentImage == UIImage(systemName: "pencil"){
            let evc = EditProfileVC()
            if sender.tag == 1 {
                evc.profileName = label1.text
                evc.profileImageURL = profileURL
            } else if sender.tag == 2{
                evc.profileName = label2.text
                evc.profileImageURL = profileURL2
            }else if sender.tag == 3{
                evc.profileName = label3.text
                evc.profileImageURL = profileURL3
            } else if sender.tag == 4{
                evc.profileName = label4.text
                evc.profileImageURL = profileURL4
            }
            evc.delegate = self
            evc.count = count
            present(evc, animated: true)
        }
        else {
            let mvc = MainTabBarViewController()
            mvc.modalPresentationStyle = .fullScreen
            mvc.isModalInPresentation = true
            if sender.tag == 1 {
                mvc.profileName = label1.text ?? ""
                mvc.profileImage = button.currentImage
            } else if sender.tag == 2{
                mvc.profileName = label2.text ?? ""
                mvc.profileImage = button2.currentImage
            } else if sender.tag == 3{
                mvc.profileName = label3.text ?? ""
                mvc.profileImage = button3.currentImage
            } else{
                mvc.profileName = label4.text ?? ""
                mvc.profileImage = button4.currentImage
            }
            delegate?.reload()
            present(mvc, animated: true)
        }
    }
    
    @objc func editButtonAction(_ sender: UIBarButtonItem){
        if sender.title == "Edit" {
            sender.title = "Okey"
            if button.currentImage != UIImage(systemName: "plus") {
                button.setImage(UIImage(systemName: "pencil"), for: .normal)
                button.kf.setBackgroundImage(with: profileURL, for: .normal)
                if button2.currentImage != UIImage(systemName: "plus") {
                    button2.setImage(UIImage(systemName: "pencil"), for: .normal)
                    button2.kf.setBackgroundImage(with: profileURL2, for: .normal)
                    if button3.currentImage != UIImage(systemName: "plus") {
                        button3.setImage(UIImage(systemName: "pencil"), for: .normal)
                        button3.kf.setBackgroundImage(with: profileURL3, for: .normal)
                        if button4.currentImage != UIImage(systemName: "plus") {
                            button4.setImage(UIImage(systemName: "pencil"), for: .normal)
                            button4.kf.setBackgroundImage(with: profileURL4, for: .normal)
                        }
                    }
                }
            }
        } else {
            viewWillAppear(true)
        }
        
    }
}
