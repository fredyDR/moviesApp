//
//  detailsMovieViewController.swift
//  moviesApp
//
//  Created by Daniel Garcia on 03/12/20.
//

import UIKit
import Alamofire


class detailsMovieViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tituloMovie: UILabel!
    @IBOutlet weak var DescripcionMovie: UILabel!
    
    let result = NSMutableAttributedString()
    var subtemas = ["Duración:","Fecha de estreno:","Calificación:","Generos:","Descripción:"]
    var idMovie : Int = 0
    var url : String!
    var titulo : String!
    var time : Int = 0
    var fecha : String!
    var puntuacion : Double = 0.0
    var resumen : String!
    var generos = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        obtenerDetalles(){ [self] (success, detalles) in
            if success{
                self.url = detalles!.backdrop_path
                self.titulo = detalles!.title
                self.time = detalles!.runtime
                self.fecha = detalles!.release_date
                self.puntuacion = detalles!.vote_average
                self.resumen = detalles!.overview
                for gen in detalles!.genres{
                    generos.append(gen.name)
                }
                setUpTxt()
                setUpView()
            }
        }
    }
    
    @IBAction func dismissView()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpTxt()
    {
        //"Duración:","Fecha de estreno:","Calificación:","Generos:","Descripción:"
        var gen = ""
        for dat in generos{
            gen = gen + dat + ","
        }
        gen.removeLast()
        let descripcionLine01 = NSMutableAttributedString(string: subtemas[0])
        let descripcionLine02 = NSMutableAttributedString(string: String(self.time))
        let descripcionLine03 = NSMutableAttributedString(string: subtemas[1])
        let descripcionLine04 = NSMutableAttributedString(string: self.fecha!)
        let descripcionLine05 = NSMutableAttributedString(string: subtemas[2])
        let descripcionLine06 = NSMutableAttributedString(string: String(self.puntuacion))
        let descripcionLine07 = NSMutableAttributedString(string: subtemas[3])
        let descripcionLine08 = NSMutableAttributedString(string: gen)
        let descripcionLine09 = NSMutableAttributedString(string: subtemas[4])
        let descripcionLine10 = NSMutableAttributedString(string: self.resumen)
        let saltoLinea = NSMutableAttributedString(string: "\n")
        let saltoLineaDoble = NSMutableAttributedString(string: "\n\n")
        
        descripcionLine01.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: NSRange(location: 0, length: subtemas[0].count))
        descripcionLine02.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .regular), range: NSRange(location: 0, length: String(self.time).count))
        descripcionLine03.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: NSRange(location: 0, length: subtemas[1].count))
        descripcionLine04.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .regular), range: NSRange(location: 0, length: self.fecha.count))
        descripcionLine05.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: NSRange(location: 0, length: subtemas[2].count))
        descripcionLine06.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .regular), range: NSRange(location: 0, length: String(self.puntuacion).count))
        descripcionLine07.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: NSRange(location: 0, length: subtemas[3].count))
        descripcionLine08.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .regular), range: NSRange(location: 0, length: gen.count))
        descripcionLine09.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: NSRange(location: 0, length: subtemas[4].count))
        descripcionLine10.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .regular), range: NSRange(location: 0, length: self.resumen.count))
        
        result.append(descripcionLine01)
        result.append(saltoLinea)
        result.append(descripcionLine02)
        result.append(saltoLineaDoble)
        result.append(descripcionLine03)
        result.append(saltoLinea)
        result.append(descripcionLine04)
        result.append(saltoLineaDoble)
        result.append(descripcionLine05)
        result.append(saltoLinea)
        result.append(descripcionLine06)
        result.append(saltoLineaDoble)
        result.append(descripcionLine07)
        result.append(saltoLinea)
        result.append(descripcionLine08)
        result.append(saltoLineaDoble)
        result.append(descripcionLine09)
        result.append(saltoLinea)
        result.append(descripcionLine10)
        
    }
    func setUpView()
    {
        let urlDownload = "https://image.tmdb.org/t/p/w500\(self.url!)"
        getProfilePictureFromUrl(urlDownload, idMovie){ (image) -> Void in
            if let image = image{
                print("Imagen descargada")
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.imageView.contentMode = .scaleToFill
                }
            }else{
                print("Sin imagen")
            }
        }
        self.tituloMovie.text = self.titulo
        self.DescripcionMovie.attributedText = result
        
    }

    func obtenerDetalles(_ completion: @escaping (Bool, detailsMovie?) -> ())
    {
        print("Obteniendo detalles de la pelicula...")
        let update : [String: Any] = ["api_key" : "634b49e294bd1ff87914e7b9d014daed",
                                      "lenguage": "en-US"]
        let url = "https://api.themoviedb.org/3/movie/\(idMovie)"
        
        let request = AF.request(url, parameters: update)
        
        request.responseData{ (data) in
            let json = data.data
            do{
                let decoder = JSONDecoder()
                let result = try decoder.decode(detailsMovie.self, from: json!)
                completion(true,result)
            }catch let DecodingError.dataCorrupted(context) {
                print(context)
                completion(false,nil)
                //completion(false,nil,"Error al obtener datos")
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                completion(false,nil)
                //completion(false,nil,"Error al obtener datos")
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                completion(false,nil)
                //completion(false,nil,"Error al obtener datos")
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                completion(false,nil)
                //completion(false,nil,"Error al obtener datos")
            } catch {
                print("error: ", error)
                completion(false,nil)
                //completion(false,nil,"Error al obtener datos")
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
