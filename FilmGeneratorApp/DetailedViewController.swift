//
//  DetailedViewController.swift
//  FilmGeneratorApp
//
//  Created by Andrey Vanakoff on 25/09/2021.
//

import UIKit

// MARK: Data
private let pulpFictionInfoURL = "https://www.omdbapi.com/?t=Pulp+Fiction&apikey=cb203dd4"
private let pulpFictionImageURL = "https://m.media-amazon.com/images/M/MV5BNGNhMDIzZTUtNTBlZi00MTRlLWFjM2ItYzViMjE3YzI5MjljXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg"

class DetailedViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieImageView: UIImageView!
    @IBOutlet var moviePlotLabel: UILabel!
    @IBOutlet var movieActorsLabel: UILabel!
    @IBOutlet var movieAwardsLabel: UILabel!
    
    //MARK: Settings
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    //MARK: Actions
    func fetchData() {
        guard let url = URL(string: pulpFictionInfoURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                
                DispatchQueue.global().async {
                    guard let imageURL = URL(string: pulpFictionImageURL) else { return }
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }
                    DispatchQueue.main.async {
                        self.movieTitleLabel.text = film.Title
                        self.moviePlotLabel.text = film.Plot
                        self.movieActorsLabel.text = "Starring: \(film.Actors)"
                        self.movieAwardsLabel.text = "Awards: \(film.Awards)"
                        self.movieImageView.image = UIImage(data: imageData)
                    }
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
}






