//
//  ViewController.swift
//  moviesApp
//
//  Created by Daniel Garcia on 03/12/20.
//

import UIKit
import Alamofire

class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var peliculas = [film]()
    
    let celda = "showMoviesTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        // Do any additional setup after loading the view.callSuscripcionMedico(key: llave!, secret_key: llave_secreta!){ (success, plans, msj) in
        obtenerData(){ (success, titulos) in
            if success{
                print("Peliculas: \(String(describing: titulos?.count))")
                self.peliculas = titulos!
                print("Pelicula: \(self.peliculas[1].original_title)")
                self.tableView.reloadData()
            }else{
                print("No hay peliculas")
            }
        }
    }
    
    func setUpTableView()
    {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: celda, bundle: nil), forCellReuseIdentifier: celda)
    }
    
    func obtenerData(_ completion: @escaping (Bool, [film]?) -> ())
    {
        let update : [String: Any] = ["api_key" : "634b49e294bd1ff87914e7b9d014daed",
                                         "language" : "en-US",
                                         "page" : 1]
        let url = "https://api.themoviedb.org/3/movie/now_playing"
        
        let request = AF.request(url, parameters: update)
        
        request.responseData{ (data) in
            print("Data: \(data)")
            let json = data.data
            var movies = [film]()
            do{
                let decoder = JSONDecoder()
                let result = try decoder.decode(Root.self, from: json!)
                //print("Peliculas: \(result.films)")
                movies = result.films
                completion(true,movies)
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
    
    func goToShowDetails(idMovie : Int)
    {
        print("Pelicula con ID: \(idMovie)")
        let vc = detailsMovieViewController()
        vc.idMovie = idMovie
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - Extenciones
extension ViewController: UITableViewDelegate{
    
}

extension ViewController: UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Numero de peliculas: \(peliculas.count / 2)")
        return peliculas.count / 2
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return listaPeliculas(tableView, indexPath)
    }
    
    func listaPeliculas(_ tableView:UITableView, _ indexPath:IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: celda, for: indexPath)
        if let cell = cell as? showMoviesTableViewCell{
            print("IndexPath: \(peliculas[indexPath.row].backdrop_path)")
            let pos = indexPath.row * 2
            cell.setUpCellLeft(data: peliculas[pos])
            cell.showDetailsLeft = { id in
                self.goToShowDetails(idMovie: self.peliculas[pos].id)
            }
            cell.setUpCellRight(data: peliculas[pos + 1])
            cell.showDetailsRight = { id in
                self.goToShowDetails(idMovie: self.peliculas[pos + 1].id)
            }
        }
        return cell
    }
    
}

