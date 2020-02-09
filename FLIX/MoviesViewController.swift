//
//  MoviesViewController.swift
//  FLIX
//
//  Created by Christian on 1/30/20.
//  Copyright © 2020 Jane. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    //step 1 to step up table view *make sure view is alrady on before you put tableView*
    @IBOutlet var tableView: UITableView!
    
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //step 3 to step up table view
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            self.movies = dataDictionary["results"] as! [[String:Any]]
            
            self.tableView.reloadData()
            
            print(dataDictionary)

              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()

        // Do any additional setup after loading the view.
    }
    //step 2 to step up table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        // Getting URL from the API
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)!
        // set this after you get podfile set up
        cell.posterView.af_setImage(withURL: posterUrl)
        
        return cell
    }
    // To use cocopods in terminal direct with cd to xcode project
    //EX: cd desktop/FLIX
    // then "pod init" still in terminal to create podfile
    // go open the podfile in files of your project and
    // put in your pod type you want
    //EX: # Pods for FLIX
    //   pod "AlamofireImage"
    // Go back to terminal to put "pod install"
    // close xcode and go to files of project to open your workspace
    // of your file EX: FLIX.xcworkspace to now be able to access third party libraries
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // This func below helps whe you leaving the screen and you want tp prepare the next screen.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Loading up the details screen")
        
        // Find the selected movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        //Pass the selected movie to the details view controller
        let detailsViewController = segue.destination as! MovieDetailViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
