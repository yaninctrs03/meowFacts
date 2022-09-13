//
//  MeowTableViewController.swift
//  meow
//
//  Created by Yanin Contreras on 13/09/22.
//

import UIKit

class MeowTableViewController: UITableViewController {
    
    //MARK: Variables&Constantes
    var service = FactsAPIService()
    var facts = [String]()
    
    //MARK: IBActions
    @IBAction func refreshData(_ sender: UIBarButtonItem) {
        Task {
            await reloadFacts()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Task{
            await reloadFacts()
        }
        
    }
    
    //MARK: Funcs
    func reloadFacts() async -> Void {
        do{
            let random = Int.random(in: 1...25)
            facts = try await service.getFacts(count: random)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }


}

//MARK: - TableView DataSource
extension MeowTableViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCell, for: indexPath)
        
        cell.textLabel?.text = facts[indexPath.row]
        
        return cell
    }
}

