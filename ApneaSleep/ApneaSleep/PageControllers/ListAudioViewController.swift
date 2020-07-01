//
//  ListAudioViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 15/06/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import os.log
import SwiftyJSON

class ListAudioViewController: UIViewController {
    var audios = [AudioList]()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ListAudioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AudioViewCell", for: indexPath) as? AudioViewCell else {
            fatalError("The dequeued cell is not an instance of AudioViewCell")
        }
        cell.selectionStyle = .none
        cell.audioName.text = audios[indexPath.row].audioName
        switch audios[indexPath.row].status {
            case "F":
                cell.audioStatus.text = "Analisado"
            case "E":
                cell.audioStatus.text = "Erro"
            default:
                cell.audioStatus.text = "None"
        }
        cell.audioDate.text = audios[indexPath.row].inclusionDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AudioDetailViewController") as? AudioDetailViewController
        vc?.audio = audios[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}


class AudioViewCell: UITableViewCell{
    @IBOutlet weak var audioName: UILabel!
    @IBOutlet weak var audioDate: UILabel!
    @IBOutlet weak var audioStatus: UILabel!
    var id: String = ""
}
