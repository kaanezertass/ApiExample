
import UIKit

class ViewController: UIViewController {

    private var tableView: UITableView = { //TableView Oluşturmak
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView'i eklemek
        view.addSubview(tableView)

        // TableView için constraints ayarlamak
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // TableView için veri kaynağını ve delegesini ayarlamak
        tableView.dataSource = self
        tableView.delegate = self

        // API'den veri çekme fonksiyonu
        fetchDataFromAPI()
    }

    func fetchDataFromAPI() {
        guard let apiUrl = URL(string: "https://jsonplaceholder.typicode.com/posts") else { //verilerin urli
            print("Geçersiz API URL") //veri çekilmediyse hata durumunda print vermek
            return
        }

        URLSession.shared.dataTask(with: apiUrl) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if let error = error {
                print("API request error: \(error)")
                return
            }

            guard let data = data else {
                print("Invalid data received")
                return
            }

            do {
                let decodedData = try JSONDecoder().decode([Post].self, from: data)

                // Verileri ana dizimize eklemek
                self.posts = decodedData

                // Ana iş parçacığında TableView'i güncellemek
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(" \(error)")
            }
        }.resume()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")

        let post = posts[indexPath.row]

        // Hücreyi doldur
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.body

        return cell
    }
}
