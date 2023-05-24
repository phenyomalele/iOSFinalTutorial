//
//  ToDoViewController.swift
//  FinalTutorial
//
//  Created by DA MAC M1 117 on 2023/05/24.
//

import UIKit

class ToDoViewController: UIViewController {
    
    var array = [Todo]()
    
    //search variables
    var searchingArray = [String]()
    var searching = false
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchApiData(URL: "https://jsonplaceholder.typicode.com/todos") { result in
            self.array = result
            print(result)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    //api function
    func fetchApiData(URL url: String, completion: @escaping([Todo]) -> Void){
        guard let url = URL(string: url) else {return}
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            if data != nil, error == nil {
                do{
                    let parsingData = try JSONDecoder().decode([Todo].self, from:data!)
                    completion(parsingData)
                }
                catch{
                    print("parsing data")
                }
                
            }
            
        }
        dataTask.resume()
        
    }
}
//
extension ToDoViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchingArray.count
        } else {
            return array.count
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoTableViewCell", for: indexPath) as? ToDoTableViewCell else { return UITableViewCell() }
        if searching {
            
            cell.textLabel?.text = searchingArray[indexPath.row]
        } else {
            cell.titleLabel.text = array[indexPath.row].title
            cell.idLabel.text = "\(array[indexPath.row].id)"
        }
        return cell
    }
    
    //delete
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        array.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    //search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //searchingArray = array.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        
        vc?.numLabel = "\(array[indexPath.row].id)"
        vc?.titleLbl = array[indexPath.row].title
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
