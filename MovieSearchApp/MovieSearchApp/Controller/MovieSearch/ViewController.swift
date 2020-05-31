//
//  ViewController.swift
//  MovieSearchApp
//
//  Created by Spoorthy Kancharla on 31/5/20.
//  Copyright © 2020 Spoorthy Kancharla. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UITextFieldDelegate,AlbumErrorDelegate {
    
    var searchTextField = UITextField()
    var activityView = UIActivityIndicatorView()
    var errorDelegate :AlbumErrorDelegate?
    var movieResults = [Movie]()
    var movieDetails:MovieDetails?
    
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MovieCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    func setupUI(){
        
        //create search textfield
        searchTextField.delegate = self
        searchTextField.placeholder = "Enter Movie name here"
        searchTextField.font = UIFont.systemFont(ofSize: 15)
        searchTextField.borderStyle = UITextField.BorderStyle.roundedRect
        searchTextField.autocorrectionType = UITextAutocorrectionType.no
        searchTextField.keyboardType = UIKeyboardType.default
        searchTextField.returnKeyType = UIReturnKeyType.done
        searchTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        searchTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        self.view.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -40)
        ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        if let movieName = textField.text{
           getMovieDetails(movieName: movieName)
        }else{
            AlertController.showAlert(message: "Enter a Movie Name", title: "Error", vc: self, buttonText: "Close")
        }
        return true
    }
    
    func getMovieDetails(movieName :  String){
        //display progress dialog
        activityView = AlertController.showActivityIndicator(view: self.view)
        activityView.startAnimating()
        
        //check if device is connected to network
        if(NetworkManager.isConnectedtoNetwork()){
            //call itunes web service to get top albums
            let url = host+"?apikey=\(apiKey)&s=%22\(movieName)%22&type=Movie"
            //call webservice api
            NetworkManager.fetchAlbums(urlString: url, completionHandler: { (data, error) in
                //parse response
                do {
                    if let responseData = data{
                        let response = try JSONDecoder().decode(MovieResult.self, from: responseData)
                            self.movieResults = response.Search
                            self.collectionView.reloadData()
                            if(self.activityView.isAnimating){
                            self.activityView.stopAnimating()
                            }
                    }else{
                        self.errorDelegate?.showErrorMessage(message: dataError, title: dataErrorTitle,vc: self,buttonText: closeButtonText)
                    }
                }catch{
                    
                }
            })
        }else{
            errorDelegate?.showErrorMessage(message: networkError, title: networkErrorTitle,vc: self,buttonText: closeButtonText)
        }
    }
    /**
     showErrorMessage - implemented protocol.
     Showing the alert dialog
     */
    func showErrorMessage(message: String, title: String, vc: ViewController, buttonText: String){
        DispatchQueue.main.async {
            AlertController.showAlert(message: message,title: title,vc: vc,buttonText: buttonText)
            if(self.activityView.isAnimating){
                self.activityView.stopAnimating()
            }
        }
    }

}

protocol AlbumErrorDelegate {
    
    func showErrorMessage(message: String, title: String, vc: ViewController, buttonText: String)
}


extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MovieCell{
            if(self.movieResults.count > 0){
                cell.data = self.movieResults[indexPath.item]
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let selectedAlubm = self.movieResults[indexPath.row]
        let vc = MovieDetailsViewController()
        vc.albumDetails = selectedAlubm
        let navigation = UINavigationController(rootViewController: vc)
        self.present(navigation, animated: true, completion: nil)
        
    }
}
