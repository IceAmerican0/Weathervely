//
//  LifeCycleTest.swift
//  Weatherbly
//
//  Created by 최수훈 on 1/26/24.
//

import Foundation

class LifeCycleTestViewController: RxBaseViewController<EmptyViewModel> {
    
    override init(_ viewModel: EmptyViewModel) {
        super.init(viewModel)
        
        print("LifeCycleTest", #function)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        print("LifeCycleTest required", #function)
    }
    
    override func loadView() {
        super.loadView()
        
        print("LifeCycleTest", #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LifeCycleTest", #function)
      container.backgroundColor = .yellow
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("LifeCycleTest", #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("LifeCycleTest", #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("LifeCycleTest", #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("LifeCycleTest", #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("LifeCycleTest", #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("LifeCycleTest", #function)
    }
    
}
