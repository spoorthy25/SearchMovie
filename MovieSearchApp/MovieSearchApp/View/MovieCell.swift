//
//  MovieCell.swift
//  MovieSearchApp
//
//  Created by Spoorthy Kancharla on 31/5/20.
//  Copyright © 2020 Spoorthy Kancharla. All rights reserved.
//


import Foundation
import UIKit

/**
 AlbumTableViewCell - create TableViewCell for displaying album title,artistname and album thumbnail
 */
class MovieCell: UICollectionViewCell {
    
    var data: Movie? {
        didSet {
            guard let data = data else { return }
            let url = data.Poster
            if let imageUrl = URL(string: url){
                DispatchQueue.main.async {
                    Utilities().downloadImage(from: imageUrl,completionHandler: { (data, error) in
                        DispatchQueue.main.async {
                            if let imageData = data{
                                self.bg.image = UIImage(data: imageData)
                            }
                        }
                    })
                }
            }
            title.text = data.Title
        }
    }
    
    fileprivate let bg: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
                iv.layer.cornerRadius = 12
        return iv
    }()
    
    fileprivate let title: UILabel = {
       let iv = UILabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(bg)
        contentView.addSubview(title)
        title.numberOfLines = 0
        title.lineBreakMode = NSLineBreakMode.byWordWrapping

        bg.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 16).isActive = true
        bg.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        bg.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: title.topAnchor,constant: 0).isActive = true
                
        title.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        title.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
