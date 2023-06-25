//
//  DataOfImage.swift
//  CatsAndModules_YanaBuha
//
//  Created by Yana Buha on 30.05.2023.
//

import Foundation
import Networking
import FirebasePerformance


final class DataOfImage: ObservableObject{
    @Published var cats: [Cat] = []
    let emptyData = Networking()
    var page = 0
    
    init(){
        self.loadmore()
    }
    
    func loadmore(){
        self.page += 1
        
        let listTrace = Performance.startTrace(name: "Load Cats List")
        listTrace?.start()
        
        emptyData.load(link: "https://api.thecatapi.com/v1/images/search?api_key=live_qk4oViero4Kdwaz0WVbLWTEDmSoW2EPz9QsIGrxyxNRPsKiKkR4ZbTaveA9svUnH&limit=15&page=\(self.page)") { [weak self] imageData in
            DispatchQueue.main.async {
                self?.cats = imageData.images
                
                let imageTrace = Performance.startTrace(name: "Load Cat Image")
                imageTrace?.start()
                
                imageTrace?.stop()
            }
        }
        
        listTrace?.stop()
    }
}
