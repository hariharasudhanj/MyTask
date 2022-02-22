//
//  DetailsViewController.swift
//  Task
//
//  Created by Hariharasudhan J on 22/02/22.
//

import UIKit

class DetailsViewController: UIViewController,UISearchBarDelegate {
    var currentPage : Int = 0
    var isLoadingList : Bool = false
    var reachability:Reachabilityhelper?
    var resultArray:[[String:Any]] = []
    var filteredArray:[[String:Any]] = []


    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
fetchResponse(currentPage)
        // Do any additional setup after loading the view.
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            filteredArray = resultArray
            collectionView.reloadData()
            return

        }
        let filteredData = resultArray.filter{
            let string = $0["name"] as! String
            //return string.conta("searchText")
            return string.contains(searchText)
            
        }
        filteredArray = filteredData
        collectionView.reloadData()
    }
    func fetchResponse(_ pageNumber: Int){
      self.isLoadingList = false
      self.collectionView.reloadData()
      let pageNo:Int = pageNumber
      let url = URL(string: "https://bc19c171-e5c8-4b55-9168-6c7b5a76a581.mock.pstmn.io/products?page=\(pageNo)&count=10")!

      var request = URLRequest(url: url)

      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.setValue("application/json", forHTTPHeaderField: "Accept")

      let task = URLSession.shared.dataTask(with: url) { [self] data, response, error in
              if let data = data {
                          do {
                              let json = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,Any>
                              let arr = json!["data"]
                              resultArray = arr! as! [[String : Any]]
                            filteredArray = resultArray
                              DispatchQueue.main.async {
                                  collectionView.reloadData()
                              }
                              print(json)
                          } catch {
                              print(error)
                          }
                      } else if let error = error {
                  print("HTTP Request Failed \(error)")
              }
          }.resume()
      }
      func loadMoreItemsForList(){
            currentPage += 1
            fetchResponse(currentPage)
        }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrolling")
        
            if (((scrollView.contentOffset.x + scrollView.frame.size.width) > scrollView.contentSize.width ) && !isLoadingList){
                self.isLoadingList = true
                self.loadMoreItemsForList()
            }
        
    
}
    

}
extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionCell
        let dict = filteredArray[indexPath.row]
        
        
        cell.title.text = dict["name"] as! String
        if let url = URL(string:dict["image"] as! String){
        if let data = try? Data(contentsOf: url ) {
                // Create Image and Update Image View
            cell.imgView.image = UIImage(data: data)
           // cell.imgView?.contentMode = .center
            }
        }
//        do{
//
//            let imagedata =  try data
//            let image = UIImage(data: imagedata)
//            cell.imgView.image = image
//        }
//        catch{
//            print(error.localizedDescription)
//        }
       
        
        return cell
        }
    

}
