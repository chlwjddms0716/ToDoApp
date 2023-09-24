//
//  ViewController.swift
//  ToDoApp
//
//  Created by 최정은 on 2023/09/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var toDoTableView: UITableView!
    
    let toDoDataManager = ToDoDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toDoTableView.reloadData()
    }

    func setupTableView(){
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        
        toDoTableView.separatorStyle = .none
        
       
        toDoTableView.rowHeight = UITableView.automaticDimension
        toDoTableView.estimatedRowHeight = 300
    }

    func configureUI(){
        title = "메모"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
    }
    
  @objc func addButtonTapped(){
     performSegue(withIdentifier: "toDetailView", sender: nil)
    }
    
    // (세그웨이를 실행할때) 실제 데이터 전달 (ToDoData전달)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailView" {
            let detailVC = segue.destination as! DetailViewController
            
            guard let indexPath = sender as? IndexPath else { return }
            detailVC.toDoData = toDoDataManager.getToDoDataList()[indexPath.row]
        }
    }
}


extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return toDoTableView.rowHeight
    }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoDataManager.deleteToDoData(data: toDoDataManager.getToDoDataList()[indexPath.row]) {
                print("삭제 완료")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
        }
    }
    
  
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoDataManager.getToDoDataList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = toDoTableView.dequeueReusableCell(withIdentifier: Cell.ToDoTableViewCellIdentifier, for: indexPath) as! ToDoTableViewCell
        
        cell.toDoData = toDoDataManager.getToDoDataList()[indexPath.row]
        cell.updateButtonTapped = { [weak self] cell in
            
            self?.performSegue(withIdentifier: "toDetailView", sender: indexPath)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}
