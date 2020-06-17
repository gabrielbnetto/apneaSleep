//
//  ListAudioViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 15/06/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import os.log

class ListAudioViewController: UIViewController {
    var audios = [AudioList]()
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleAudios()
    }
    
    private func loadSampleAudios(){
        let audio1 = AudioList(audioName: "Teste1", audioDate: "27/11/1998", audioId: "1")
        let audio2 = AudioList(audioName: "Teste2", audioDate: "27/11/1998", audioId: "1")
        let audio3 = AudioList(audioName: "Teste3", audioDate: "27/11/1998", audioId: "1")
        let audio4 = AudioList(audioName: "Teste4", audioDate: "27/11/1998", audioId: "1")
        
        audios += [audio1, audio2, audio3, audio4]
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
        cell.audioDate.text = audios[indexPath.row].audioDate
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
    var id: String = ""
}
