//
//  ViewController.swift
//  JsonDecodeSwift4Vs4_1
//
//  Created by De La Cruz, Eduardo on 20/11/2018.
//  Copyright © 2018 De La Cruz, Eduardo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    struct Course: Decodable {
        let id: Int
        let name: String
        let link: String
        
//        let number_of_lessons: Int
        let numberOfLessons: Int
        let imageUrl: String
        
        // Swift 4.0: In order to use Swift 4.0 version coment line 56 and discoment 23-27
//        private enum CodingKeys: String, CodingKey {
//            case imageUrl = "image_url"
//            case numberOfLessons = "number_of_lessons"
//            case id, name, link
//        }
    }
    
    var courses = [Course]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Course List"
        fetchJSON()
    }
    
    fileprivate func fetchJSON() {
        let urlString = "https://api.letsbuildthatapp.com/jsondecodable/courses_snake_case"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url: ", err)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    // link in description for video on JSONDecoder
                    let decoder = JSONDecoder()
                    // Swift 4.1: In order to use Swift 4.1 version coment line 23-27 and discoment 56
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    self.courses = try decoder.decode([Course].self, from: data)
                    self.tableView.reloadData()
                } catch let jsonErr {
                    print("Failed to decode: ", jsonErr)
                }
            }
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let course = courses[indexPath.row]
        cell.textLabel?.text = course.name
        cell.detailTextLabel?.text = String(course.numberOfLessons)
        
        return cell
    }
}
