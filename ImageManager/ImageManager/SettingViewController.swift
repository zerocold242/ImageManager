//
//  SettingViewController.swift
//  ImageManager
//
//  Created by Aleksey Lexx on 19.02.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var sortDelegate: SortContentsDelegate?
    
    private lazy var settingTableView: UITableView = {
        let settingTable = UITableView.init(frame: .zero, style: .grouped)
        settingTable.rowHeight = UITableView.automaticDimension
        settingTable.translatesAutoresizingMaskIntoConstraints = false
        return settingTable
    }()
    
    private func setUpTableView() {
        view.addSubview(settingTableView)
        settingTableView.dataSource = self
        settingTableView.delegate = self
        settingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        NSLayoutConstraint.activate([
            settingTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "Settings"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNavigationBar()
        setUpTableView()
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let switchButton = UISwitch()
        switchButton.addTarget(self, action: #selector(pushSwith), for: .valueChanged)
        let isSort = UserDefaults.standard.bool(forKey: "A - Z") == true ||
        (UserDefaults.standard.object(forKey: "A - Z") != nil) == false
        switchButton.tag = indexPath.row
        switchButton.setOn(isSort, animated: true)
        
        switch indexPath.row {
        case 0:
            cell.accessoryView = switchButton
                cell.textLabel?.text = "Sorting from A to Z"
            return cell
        default:
            cell.textLabel?.text = "Change password"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.section == 0 {
                UserDefaults.standard.set(true, forKey: "ChangePass")
                LoginInspector.shared.removePassword()
               openLoginVC()
            }
        }
    
    @objc func pushSwith(_ sender: UISwitch!){
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "A - Z")
            print("Sorting  A - Z")
        } else {
            UserDefaults.standard.set(false, forKey: "A - Z")
            print("Unsorting A - Z")
        }
        //witch sender.tag {
        //      case 0:
        //          sender.isOn ? UserDefaults.standard.set(true, forKey: "sort") : UserDefaults.standard.set(false, forKey: "sort")
        //      case 1:
        //          sender.isOn ? UserDefaults.standard.set(true, forKey: "size") : UserDefaults.standard.set(false, forKey: "size")
        //      default:
        //          print("print")
        //      }
               //self.settingTableView.reloadData()
        self.sortDelegate?.sortingAZ()
    }
    
    func openLoginVC() {
            let loginViewController: LoginViewController = LoginViewController(authMode: .changePassword)
         navigationController?.present(loginViewController, animated: true, completion: nil)
        }
}

