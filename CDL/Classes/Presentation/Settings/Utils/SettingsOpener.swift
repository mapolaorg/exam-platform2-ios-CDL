//
//  SettingsOpener.swift
//  CDL
//
//  Created by Andrey Chernyshev on 24.04.2021.
//

import UIKit
import RxSwift

final class SettingsOpener {
    enum Screen {
        case locale, topics, mode(TestMode)
    }
    
    private lazy var disposeBag = DisposeBag()
    
    func open(screen: Screen, from: UIViewController) {
        let view = makeView(for: screen)
        let vc = makeVC(with: view)
        
        view.vc = vc

        view.didNextTapped = {
            vc.dismiss(animated: true)
        }

        from.present(vc, animated: true)
    }
}

// MARK: Private
private extension SettingsOpener {
    func makeVC(with view: UIView) -> UIViewController {
        let vc = UIViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.view.backgroundColor = UIColor(integralRed: 41, green: 55, blue: 137)
        vc.view.addSubview(view)
        
        let closeButton = UIButton()
        closeButton.frame.origin = CGPoint(x: 16.scale, y: 64.scale)
        closeButton.frame.size = CGSize(width: 24.scale, height: 24.scale)
        closeButton.setImage(UIImage(named: "Settings.Close"), for: .normal)
        vc.view.addSubview(closeButton)
        
        closeButton.rx.tap
            .subscribe(onNext: {
                vc.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        return vc
    }
    
    func makeView(for screen: Screen) -> SSlideView {
        let view: SSlideView

        switch screen {
        case .locale:
            view = STChangeLocaleView()
        case .topics:
            view = SSlideTopicsView()
            view.moveToThis()
        case .mode:
            view = SSlideModeView()
        }

        view.frame = UIScreen.main.bounds

        return view
    }
}
