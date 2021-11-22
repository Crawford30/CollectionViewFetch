//
//  ViewController.swift
//  FetchReward
//
//  Created by JOEL CRAWFORD on 11/23/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    
    let myVertCellSize:  CGSize  = CGSize( width: 343, height: 188 )
    
    let myVertCVSpacing: CGFloat = CGFloat( 4.0 ) //vertical spacing for
    
    
    
    var categoryArray: [Categories] = []
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!

    let apiString  = "https://www.themealdb.com/api/json/v1/1/categories.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    
        fetchCategories()
    }
    
    
    
    
    private func fetchCategories() {
        let session  = URLSession.shared
        let url = URL(string: apiString)!
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {
                print("Client error!")
                return
            }
        
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, AnyObject>
                var tempID: Categories
                self.categoryArray = []
            
                let catData = json?["categories"]
        
                for eachData in catData as! [Dictionary<String, AnyObject>] {
//                    print(eachData["idCategory"])
                    
                    tempID = Categories.init()
                    tempID.catID = eachData["idCategory"] as! String
                    tempID.catName  = eachData["strCategory"] as! String
                    tempID.catImage = eachData["strCategoryThumb"] as! String
                    tempID.catDesc = eachData["strCategoryDescription"] as! String
                    
                    
                    self.categoryArray.append( tempID )
                    
                    
                    self.categoryArray.sort {
                        $0.catName.lowercased() < $1.catName.lowercased()
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.categoryCollectionView.reloadData()
                    }
                    
                   
                    
                    //return
                }
                
                
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.catNameLabel.text = categoryArray[indexPath.item].catName
        cell.catDescLabel.text = categoryArray[indexPath.item].catDesc
        
        cell.imageView.loadImageUsingCacheFromUrlString(urlString: categoryArray[indexPath.item].catImage)
        cell.imageView.contentMode = .scaleAspectFit
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // print("sizeForItemAt hit!")
        
        return myVertCellSize
        
    }
    
}



extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: myVertCVSpacing, left: myVertCVSpacing, bottom: myVertCVSpacing, right: myVertCVSpacing)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return myVertCVSpacing
        
    }
    
}
