//
//  ViewController.swift
//  VargasASoundBoard2
//
//  Created by Albert Vargas on 9/10/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    var reproducirAudio:AVAudioPlayer?
    
    @IBOutlet weak var tablaGrabacione: UITableView!
    var grabaciones:[Grabacion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaGrabacione.dataSource = self
        tablaGrabacione.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            grabaciones = try
            context.fetch(Grabacion.fetchRequest())
            tablaGrabacione.reloadData()
        }catch{}
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grabaciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let grabacion = grabaciones[indexPath.row]
        cell.textLabel?.text = grabacion.nombre
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let grabacion = grabaciones[indexPath.row]
        do{
            reproducirAudio = try AVAudioPlayer(data: grabacion.audio! as Data)
            reproducirAudio?.play()
        }catch{}
        
        tablaGrabacione.deselectRow(at: indexPath, animated: true)
        
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let grabacion = grabaciones[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(grabacion)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do{
                grabaciones = try
                context.fetch(Grabacion.fetchRequest())
                tablaGrabacione.reloadData()
            }catch{}
        }
    }
    
    

}

