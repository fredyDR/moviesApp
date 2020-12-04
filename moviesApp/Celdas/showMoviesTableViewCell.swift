//
//  showMoviesTableViewCell.swift
//  moviesApp
//
//  Created by Daniel Garcia on 03/12/20.
//

import UIKit

class showMoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var viewLeft: UIView!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var tituloLeft: UILabel!
    @IBOutlet weak var fechaLeft: UILabel!
    @IBOutlet weak var puntuacionLeft: UILabel!
    @IBOutlet weak var subViewLeft: UIView!
    @IBOutlet weak var imageLeft: UIImageView!
    
    @IBOutlet weak var viewRight: UIView!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var tituloRight: UILabel!
    @IBOutlet weak var fechaRight: UILabel!
    @IBOutlet weak var puntuaciónRight: UILabel!
    @IBOutlet weak var subViewRight: UIView!
    @IBOutlet weak var imageRight: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageLeft.layer.cornerRadius = 12
        imageRight.layer.cornerRadius = 12
        
        subViewRight.rC(corners: [.bottomLeft, .bottomRight], radius: 12)
        subViewLeft.rC(corners: [.bottomLeft, .bottomRight], radius: 12)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var idL: Int = 0
    var idR: Int = 0
    
    var showDetailsLeft : ((_ id: Int) -> Void)?
    var showDetailsRight : ((_ id: Int) -> Void)?
    
    @IBAction func detailsShowLeft()
    {
        showDetailsLeft?(idL)
    }
    
    @IBAction func detailsShowRight()
    {
        showDetailsRight?(idR)
    }
    
    func setUpCellLeft(data: film)
    {
        idL = data.id
        tituloLeft.text = data.original_title
        fechaLeft.text = data.release_date
        puntuacionLeft.text = String(data.vote_average)
        let urlDownload = "https://image.tmdb.org/t/p/w500\(data.poster_path)"
        getProfilePictureFromUrl(urlDownload, data.id){ (image) -> Void in
            if let image = image{
                print("Imagen descargada")
                DispatchQueue.main.async {
                    self.imageLeft.image = image
                    self.imageLeft.contentMode = .scaleToFill
                }
            }else{
                print("Sin imagen")
            }
        }
    }
    
    func setUpCellRight(data: film)
    {
        idR = data.id
        tituloRight.text = data.original_title
        fechaRight.text = data.release_date
        puntuaciónRight.text = String(data.vote_average)
        let urlDownload = "https://image.tmdb.org/t/p/w500\(data.poster_path)"
        getProfilePictureFromUrl(urlDownload, data.id){ (image) -> Void in
            if let image = image{
                print("Imagen descargada")
                DispatchQueue.main.async {
                    self.imageRight.image = image
                    self.imageRight.contentMode = .scaleToFill
                }
            }else{
                print("Sin imagen")
            }
        }
    }
    
    func getProfilePictureFromUrl(_ urlString: String,_ id_movie:Int, handler:@escaping (_ image:UIImage?)-> Void){
            
            let imageURL: URL = URL(string: urlString)!
            URLSession.shared.dataTask(with: imageURL) { (data, _, _) in
                if let data = data{
                    /*print("guardando...")*/
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let fileURL = documentsURL.appendingPathComponent("\(id_movie).jpg")
                    let imagePath = fileURL.path
                    try? data.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
                    //print("imagen guardada en: " + imagePath)
                    handler(UIImage(data: data))
                }else{
                    print("No URL")
                }
            }.resume()
        }

    
}

extension UIView
{
    func rC(corners:UIRectCorner, radius: CGFloat)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
