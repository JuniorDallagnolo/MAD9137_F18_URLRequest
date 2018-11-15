//
//  TableViewController.swift
//  MAD9137_F18_URLRequest
//
//  Created by Ernilo Dallagnolo Junior on 2018-11-14.
//  Copyright © 2018 Ernilo Dallaagnolo Junior. All rights reserved.
//

//Create Layout: (4pt total)
//-TableViewController with embedded Navigation Controller (2pt)
//-Add Bar Button Item to nav bar in table view labeled 'Load' (1pt)
//-Give prototype cell an Identifier name (1pt)

import UIKit

//TableViewController class: (3pt total)
class TableViewController: UITableViewController {
    
    //When you capture the response data in your callback function and serialize the JSON, it will need to be stored in an array of dictionaries. Your table view needs a class property to store it that looks like this:
    //-Create jsonData object to hold response (2pt)
    var jsonArray: [[String:String]]?
    
    //-Create IBAction for 'Load' button (1pt)
    //Button Action function: (7pt total)
    //-Create button Action (1pt)
    @IBAction func btnLoad(_ sender: Any) {
        //-Create URL (1pt)
        let myUrl: URL = URL(string: "https://lenczes.edumedia.ca/mad9137/a4/respond.php")!
        //-Create Request using URL (1pt)
        let myURLRequest: URLRequest = URLRequest(url: myUrl)
        //-Create Session using shared session (1pt)
        let mySession: URLSession = URLSession.shared
        //-Create task object from session passing in request and completion handler (2pt)
        let myTask = mySession.dataTask(with: myURLRequest, completionHandler: requestTask )
        //-Execute task (1pt)
        myTask.resume()
    }
    
    //Completion Handler Request Task function: (9pt total)
    //-Create the completion handler function for the url session (2pt)
    func requestTask (_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        
        //-If the serverError is not nil, execute the callback function passing in empty string for data and description of error message (2pt)
        if serverError != nil {
           self.myCallback(responseString: "", error: serverError?.localizedDescription)
        }else{
            //-If there was no error, convert the raw data to a utf8 json string, and execute callback passing in json string data, and nil for the error (5pt)
            let result = String(data: serverData!, encoding: String.Encoding.utf8)!
           self.myCallback(responseString: result as String, error: nil)
        }
    }
    
    //Callback function: (12pt total)
    func myCallback(responseString: String, error: String?) {
      //-Output the error if it's not nil using the print method (1pt)
        if error != nil {
            print("ERROR is " + error!)
        }else{
            //-If there is no error, print the json data (1pt)
            print("Json Data is " + responseString)
            //-Convert json string to data (2pt)
            if let myData: Data = responseString.data(using: String.Encoding.utf8) {
                do {
                    //-Attempt to convert the data to a json object stored in the jsonData object (3pt)
                    jsonArray = try JSONSerialization.jsonObject(with: myData, options: []) as? [[String:String]]
                } catch let convertError {
                    //-Catch and print out any errors in jsonData conversion (2pt)
                    print(convertError.localizedDescription)
                }
            }
        }
    
        //-Call reloadData on tableView on main thread with dispatch async (3pt)
        DispatchQueue.main.async() {
            // Reload Table with retrieved data
            self.tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //  In your tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{} method, you will use optional binding to return the .count of the jsonArray.count and, if it is still nil, you return '0'.
    //TableView(numberOfRowsInSection) method: (3pt total)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //-Use optional binding to return json array count (2pt)
        if let count = jsonArray?.count {
            return count
        }
        //-If the json data does not exist return 0 (1pt)
        return 0
    }

    //In your override tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{} method, again you will use optional binding on the jsonArray to access it only if the data was created properly. You will need to access the dictionary of values in the array using the indexPath.row passed to the tableView function.
    //TableView(cellForRowAtIndexPath) method: (7pt total)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //-Get a copy of the dequeued reusable cell (2pt)
        let cell = tableView.dequeueReusableCell(withIdentifier: "tv_cell", for: indexPath)
        //-Use optional binding to get the jsonData object if it exists, and get the current dictionary by using the indexPath.row (3pt)
        if let eventInfo = jsonArray?[indexPath.row] {
            //-Set each tableViewCell's textLabel with the 'eventTitle' and 'eventDate' values in the current json dictionary from the jsonData array (2pt)
            let title = eventInfo["eventTitle"]
            let date = eventInfo["eventDate"]
            cell.textLabel?.text = title! + ", " + date!
        }
        return cell
    }

}
