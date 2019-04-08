//
//  tabWrokList.swift
//  ourWork
//
//  Created by taejun on 2019. 3. 31..
//  Copyright © 2019년 midasgo. All rights reserved.
//

import Foundation
import UIKit
class tabWorkListViewController:UIViewController{
    @IBOutlet weak var workTableView: UITableView!
    /******************* system function *******************/
    //-----------------------------------------------
    //
    override func viewDidLoad() {
        print("tabWorkListViewController viewDidLoad")
    }
    //-----------------------------------------------
    //
    override func viewWillAppear(_ animated: Bool) {
        print("tabWorkListViewController viewWillAppear")
    }
    //-----------------------------------------------
    //
    override func viewWillDisappear(_ animated: Bool) {
        print("tabWorkListViewController viewWillDisappear")
    }
    
    /******************* user function *******************/
}
