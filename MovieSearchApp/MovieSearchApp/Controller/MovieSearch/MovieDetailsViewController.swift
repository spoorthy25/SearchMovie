//
//  MovieDetailsViewController.swift
//  MovieSearchApp
//
//  Created by Spoorthy Kancharla on 31/5/20.
//  Copyright © 2020 Spoorthy Kancharla. All rights reserved.
//

import Foundation
import UIKit

/**
AlbumDetailsViewController - Album Detailed View Controller.
 Display the detailed view of Album
 Open itunes album when clicked button
*/
class MovieDetailsViewController: UIViewController {
    var albumDetails:Movie?
    var album: MovieDetails?
    var activityView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.white
        
        //add back button
        addNavigationButton()
        getMovieDetails()
    }
    
    /**
        addNavigationButton -  add back button to navigate back to the Home page
     */
    func addNavigationButton() {
        let backButton = UIButton(type: .custom)
        backButton.setTitle("Done", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func getMovieDetails(){
        //display progress dialog
        activityView = AlertController.showActivityIndicator(view: self.view)
        activityView.startAnimating()
        var searchedMovies = [Movie]()
        var idValue = ""
        
        //check if device is connected to network
        if(NetworkManager.isConnectedtoNetwork()){
            //call itunes web service to get top albums
            if let id = albumDetails?.imdbID {
                idValue = id
            }
            
            let url = host+"?apikey=\(apiKey)&i=\(idValue)"
            //call webservice api
            NetworkManager.fetchAlbums(urlString: url, completionHandler: { (data, error) in
                do {
                    //parse response
                    if let responseData = data as? Data{
                        let response = try JSONDecoder().decode(MovieDetails.self, from: responseData)
                        self.album = response
                        if let imageUrl = URL(string: response.Poster){
                            DispatchQueue.main.async {
                                Utilities().downloadImage(from: imageUrl,completionHandler: { (data, error) in
                                    DispatchQueue.main.async {
                                       //create ui elements to display album details
                                       self.setupAlbumView()
                                    }
                                })
                            }
                        }
                        
                        self.view.setNeedsLayout()
                        if(self.activityView.isAnimating){
                        self.activityView.stopAnimating()
                        }
                    }
                }catch{
                    
                }
            })
        }
    }

    /**
     backAction -  handle back button click
        remove this screen and move back to Home screen
     */
    @IBAction func backAction(_ sender: UIButton) {
      self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     
     let movieImageView:UIImageView = {
         let img = UIImageView()
         img.contentMode = .scaleAspectFill
         img.translatesAutoresizingMaskIntoConstraints = false
         return img
     }()
     
     let movieNameLabel:UILabel = {
         let label = UILabel()
         label.font = UIFont.boldSystemFont(ofSize: 20)
         label.textColor = .black
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0;
         label.lineBreakMode = NSLineBreakMode.byWordWrapping
         return label
     }()
     
     let movieYearLabel:UILabel = {
         let label = UILabel()
         label.font = UIFont.boldSystemFont(ofSize: 20)
         label.textColor = .black
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0;
         label.lineBreakMode = NSLineBreakMode.byWordWrapping
         return label
     }()
        
     let movieRunningLabel:UILabel = {
         let label = UILabel()
         label.font = UIFont.boldSystemFont(ofSize: 20)
         label.textColor = .black
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0;
         label.lineBreakMode = NSLineBreakMode.byWordWrapping
         return label
    }()
        
     let movieratingLabel:UILabel = {
         let label = UILabel()
         label.font = UIFont.boldSystemFont(ofSize: 20)
         label.textColor = .black
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0;
         label.lineBreakMode = NSLineBreakMode.byWordWrapping
         return label
    }()
        
    let movieSynopisiLabel:UILabel = {
         let label = UILabel()
         label.font = UIFont.boldSystemFont(ofSize: 20)
         label.textColor = .black
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0;
         label.lineBreakMode = NSLineBreakMode.byWordWrapping
         return label
    }()
    
    let movieDirectorLabel:UILabel = {
         let label = UILabel()
         label.font = UIFont.boldSystemFont(ofSize: 20)
         label.textColor = .black
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0;
         label.lineBreakMode = NSLineBreakMode.byWordWrapping
         return label
    }()
    
    let movieWriterLabel:UILabel = {
         let label = UILabel()
         label.font = UIFont.boldSystemFont(ofSize: 20)
         label.textColor = .black
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0;
         label.lineBreakMode = NSLineBreakMode.byWordWrapping
         return label
    }()
    
    let movieActorsLabel:UILabel = {
         let label = UILabel()
         label.font = UIFont.boldSystemFont(ofSize: 20)
         label.textColor = .black
         label.translatesAutoresizingMaskIntoConstraints = false
         label.numberOfLines = 0;
         label.lineBreakMode = NSLineBreakMode.byWordWrapping
         return label
    }()
    
    let stackview: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}


extension MovieDetailsViewController{
    
    /**
    setupAlbumView - create UI elements for displaying album name,artist,releasedate
    copyright
    */
    func setupAlbumView(){
       if let albumName = album?.Title {
           movieNameLabel.text = "Title : \(albumName)"
       }
       
       if let artistName = album?.Year {
           movieYearLabel.text = "Year : \(artistName)"
       }
       
       if let albumCopyright = album?.Runtime {
           movieRunningLabel.text = "Play Time : \(albumCopyright)"
       }
        
       if let albumReleaseDate = album?.imdbRating {
           movieratingLabel.text = "Rating : \(albumReleaseDate)"
       }
       
       if let albumDirector = album?.Director {
           
           movieDirectorLabel.text = "Director : \(albumDirector)"
       }
        
        if let albumWriter = album?.Writer {
            
            movieWriterLabel.text = "Writer : \(albumWriter)"
        }
        
        if let albumActors = album?.Actors {
            
            movieActorsLabel.text = "Actor : \(albumActors)"
        }
        
        if let albumGenre = album?.Plot {
            
            movieSynopisiLabel.text = "Synopsis : \n\(albumGenre)"
        }
       
       if let imageUrl = albumDetails?.Poster {
           if let fileUrl = URL(string: imageUrl){
               DispatchQueue.main.async {
                   Utilities().downloadImage(from: fileUrl,completionHandler: { (data, error) in
                       DispatchQueue.main.async {
                           if let imageData = data{
                               self.movieImageView.image = UIImage(data: imageData )
                           }
                       }
                   })
               }
           }
       }
       
       view.addSubview(movieImageView)
       
       //add constraints for album image
       NSLayoutConstraint.activate([
           movieImageView.centerXAnchor.constraint(equalTo:view.centerXAnchor),
           movieImageView.leadingAnchor.constraint(equalTo:view.leadingAnchor, constant:50),
           movieImageView.topAnchor.constraint(equalTo:view.topAnchor,constant: 70)
        
       ])
       
       view.addSubview(scrollView)
       stackview.addArrangedSubview(movieRunningLabel)
       stackview.addArrangedSubview(movieratingLabel)
       scrollView.addSubview(scrollViewContainer)
       scrollViewContainer.addArrangedSubview(movieNameLabel)
       scrollViewContainer.addArrangedSubview(movieYearLabel)
       scrollViewContainer.addArrangedSubview(stackview)
       //scrollViewContainer.addArrangedSubview(movieRunningLabel)
       //scrollViewContainer.addArrangedSubview(movieratingLabel)
       scrollViewContainer.addArrangedSubview(movieSynopisiLabel)
        scrollViewContainer.addArrangedSubview(movieDirectorLabel)
        scrollViewContainer.addArrangedSubview(movieWriterLabel)
        scrollViewContainer.addArrangedSubview(movieActorsLabel)
       
       //add constraints for UIViews
       NSLayoutConstraint.activate([
           
           //scrollview constraints
           scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8),
           scrollView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor,constant: 20),
           scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           
           //scrollview container constraints
           scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,constant: 10),
           scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
           scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
           scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
           scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        
           
       ])
    }
}
