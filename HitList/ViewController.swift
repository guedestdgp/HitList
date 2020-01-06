//
//  ViewController.swift
//  HitList
//
//  Created by Tatiane on 2020-01-06.
//  Copyright © 2020 Tatiane. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var names: [String] = []
    var people: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List"
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }


    // Implement the addName IBAction
    @IBAction func addName(_ sender: UIBarButtonItem) {
        
        //Alert
        let alert = UIAlertController(title: "New Person", message: "Add a new name, age, city, yes or no gratuate", preferredStyle: .alert)
        
        //Button Save
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else { return }
            
            let data = nameToSave.components(separatedBy: ",")
            self.save(data: data)
            self.tableView.reloadData()
        }
        
        //Button Cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func save(data: [String]) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(data[0], forKeyPath: "name")
        person.setValue(Int(data[1]), forKeyPath: "age")
        person.setValue(data[2], forKeyPath: "city")
        person.setValue(data[3] == "yes" ? true : false, forKeyPath: "graduate")
        // 4
        do {
        try managedContext.save()
            people.append(person)
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)") }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        //3
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Name: \(String(describing: person.value(forKeyPath: "name")!))" +
        " - Age: \(person.value(forKeyPath: "age")!)" +
        " - City: \(person.value(forKeyPath: "city")!)" +
        " - Graduate: \(person.value(forKeyPath: "graduate")!)"
        return cell
    }
    
}
