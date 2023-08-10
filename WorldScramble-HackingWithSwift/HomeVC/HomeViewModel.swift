//
//  HomeViewModel.swift
//  WorldScramble-HackingWithSwift
//
//  Created by Mert Deniz Akbaş on 9.08.2023.
//

import Foundation

protocol HomeViewModelProtocol {
    var view: HomeVCProtocol? { get set }
    
    func viewDidLoad()
}

final class HomeViewModel {
    weak var view: HomeVCProtocol?
    

}

extension HomeViewModel: HomeViewModelProtocol {
    func viewDidLoad(){
        view?.configureTableView()
        view?.setWord()
        view?.startGame()
        view?.setRightBarButton()
       
    }    

}
