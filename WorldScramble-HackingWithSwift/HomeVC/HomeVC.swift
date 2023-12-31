//
//  HomeVC.swift
//  WorldScramble-HackingWithSwift
//
//  Created by Mert Deniz Akbaş on 9.08.2023.
//

import UIKit


protocol HomeVCProtocol: AnyObject {
    func configureTableView()
    func setWord()
    func startGame()
    func setRightBarButton()
}
final class HomeVC: NavigationController {
   private var viewModel = HomeViewModel()
    
    var allWords = [String]()
    var usedWords = [String]()
    var errorTitle: String = ""
    var errorMessage: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    enum ReuseID: String {
        case WordCell = "Word"
    
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()

    }
    

}
extension HomeVC: HomeVCProtocol {
    func setRightBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    }
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self , weak ac] _ in
            guard let self = self else { return }
            guard let answer = ac?.textFields?[0].text else { return }
            self.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
    
            let lowerAnswer = answer.lowercased()
    
            if isPossible(word: lowerAnswer) {
                if isOriginal(word: lowerAnswer) {
                    if isReal(word: lowerAnswer){
                        usedWords.insert(answer, at: 0)
                        let  indexPath = IndexPath(row: 0, section: 0)
                        
                        tableView.insertRows(at: [indexPath], with: .automatic)
                        return
                    }else{
                        errorTitle = "Word not recognized"
                        errorMessage = "You can't just make them up, you know"
                    }
                        
                    
                }else{
                    errorTitle = "Word already used"
                    errorMessage = "Be more original!"
                }
            }else{
                guard let title = title else { return }
                errorTitle = "Word not possible"
                errorMessage = "You can't spell that word from \(title.lowercased())."
            }
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        }
    
        func isPossible(word: String) -> Bool {
            guard var tempWord = title?.lowercased() else { return false }
            for letter in word {
                if let position = tempWord.firstIndex(of: letter) {
                    tempWord.remove(at: position)
                }else {
                    return false
                }
            }
            return true
        }
        func isOriginal(word: String) -> Bool {
            return !usedWords.contains(word)
        }
        func isReal(word: String) -> Bool {
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let missspellRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            return missspellRange.location == NSNotFound
        }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func startGame() {
        title = allWords.randomElement()
      usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
  
    func setWord() {
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsUrl){
                allWords = startWords.components(separatedBy: "\n")
            }
            
            if  allWords.isEmpty {
                allWords = ["silkworm"]
            }
        }
    }
    
}


extension HomeVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.WordCell.rawValue, for: indexPath) as? WordCell {
            cell.updateCell(title: usedWords[indexPath.row])
            return cell
        }
        return UITableViewCell()

    }
    

}
