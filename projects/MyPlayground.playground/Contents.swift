import Foundation

struct Cover: Codable {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

struct Video: Codable {
    let id: String
    let name: String
    let headline: String
}



func api(path: String) {
    guard let url = URL(string: "https://swiftapi.azurewebsites.net/\(path)") else {
        return
    }
//    URLSession.shared.dataTask(with: <#T##URLRequest#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>
//    let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data, error == nil else {
            return
        }
        guard let covers = try? JSONDecoder().decode([Cover].self, from: data) else {
            return
        }
        for cover in covers {
            print(cover.id, cover.name)
        }
    }.resume()
//    session.resume()
}


func api2(path: String, completion: @escaping ([Cover]?) -> Void) {
    guard let url = URL(string: "https://swiftapi.azurewebsites.net/\(path)") else {
        completion(nil)
        return
    }
    let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        
        let results = try? JSONDecoder().decode([Cover].self, from: data)
        completion(results)
    }
    session.resume()
}

//generic
func api3<T: Codable>(get path: String, completion: @escaping ([T]?) -> Void) {
    guard let url = URL(string: "https://swiftapi.azurewebsites.net/\(path)") else {
        completion(nil)
        return
    }
    let session = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        
        let results = try? JSONDecoder().decode([T].self, from: data)
        completion(results)
    }
    session.resume()
}

func api3<T: Codable>(post path: String, payload: T, completion: @escaping (Bool) -> Void) {
    guard let url = URL(string: "https://swiftapi.azurewebsites.net/\(path)") else {
        completion(false)
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONEncoder().encode(payload)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard error == nil else {
            completion(false)
            return
        }
        completion(true)
    }.resume()
}


//api(path: "Africa/Covers")
//
//api2(path: "Africa/Covers") { (covers) in
//    guard let covers = covers else {
//        return
//    }
//    for cover in covers {
//        print(cover.id, cover.name)
//    }
//}
//
//api3(get: "Africa/Covers") { (covers: [Cover]?) in
//    guard let covers = covers else {
//        return
//    }
//    for cover in covers {
//        print(cover.id, cover.name)
//    }
//}

api3(get: "Africa/Videos") { (datas: [Video]?) in
    guard let datas = datas else {
        return
    }
    for data in datas {
        print(data.id, data.name, data.headline)
    }
}

//api3(get: "Africa/Locations") { (datas: [Video]?) in
//    guard let datas = datas else {
//        return
//    }
//    for data in datas {
//        print(data.id, data.name, data.headline)
//    }
//}

//let cover = Cover(id: 4444, name: "trust")
//api3(post: "Africa/Covers", payload: cover) { (success) in
//    print(success)
//}
