//
//  ListPresenceCoordinator.swift
//  Personal
//
//  Created by Tiago Braga on 7/30/19.
//  Copyright © 2019 Physis. All rights reserved.
//

import Foundation
import UIKit

class ListPresenceCoordinator: BaseCoordinator {
    
    lazy var controller: ListPresenceViewController = {
        let listPresenceViewController = ListPresenceViewController.instantiate()
        return listPresenceViewController
    }()
    
    let router: RouterProtocol
    
    init(viewModel: PresenceListViewModel, router: RouterProtocol) {
        self.router = router
        super.init()
        self.controller.viewModel = viewModel
    }
    
    override func start() {
        self.controller.viewModel.didTappedEditStudent = { [weak self] viewModel in
            guard let strongSelf = self else { return }
            strongSelf.newEditUser(viewModel: viewModel)
        }
    }
    
    private func newEditUser(viewModel: StudentViewModel) {
        let newEditUserCoordinator: NewEditUserCoordinator = NewEditUserCoordinator(viewModel: viewModel, router: self.router)
        self.store(coordinator: newEditUserCoordinator)
        newEditUserCoordinator.start()
        self.router.push(newEditUserCoordinator, isAnimated: true) { [weak self, weak newEditUserCoordinator] in
            guard let strongSelf = self, let newEditUserCoordinator = newEditUserCoordinator else { return }
            strongSelf.free(coordinator: newEditUserCoordinator)
        }
    }
    
}

extension ListPresenceCoordinator: Drawable {
    var viewController: UIViewController? { return controller }
}
