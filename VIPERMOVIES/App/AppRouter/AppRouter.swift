//
//  AppRouter.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

enum PresentType {
    case root
    case push
    case present
    case presentWithNavigation
    case modal
    case modalWithNavigation
}

protocol IRouter {
    var module: UIViewController? { get }
}

extension UIViewController {
    static func initialModule<T: IRouter>(module: T) -> UIViewController {
        guard let _module = module.module else { fatalError() }
        return _module
    }
    
    func navigate(type: PresentType = .push, module: IRouter, completion: ((_ module: UIViewController) -> Void)? = nil) {
        guard let _module = module.module else { fatalError() }
        switch type {
        case .root:
            if _module is UITabBarController {
                UIApplication.shared.delegate?.window??.setRootViewController(_module, options: .init(direction: .fade, style: .easeInOut))
            } else {
                UIApplication.shared.delegate?.window??.setRootViewController(
                    UINavigationController(rootViewController: _module),
                    options: .init(
                        direction: .fade,
                        style: .easeInOut
                    )
                )
            }
            completion?(_module)
        case .push:
            if let navigation = self.navigationController {
                navigation.pushViewController(_module, animated: true)
                completion?(_module)
            }
        case .present:
            self.present(_module, animated: true, completion: {
                completion?(_module)
            })
        case .presentWithNavigation:
            let nav = UINavigationController(rootViewController: _module)
            self.present(nav, animated: true, completion: {
                completion?(_module)
            })
        case .modal:
            _module.modalTransitionStyle = .crossDissolve
            _module.modalPresentationStyle = .overFullScreen
            
            self.present(_module, animated: true, completion: {
                completion?(_module)
            })
        case .modalWithNavigation:
            let nav = UINavigationController(rootViewController: _module)
            nav.modalPresentationStyle = .overFullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: {
                completion?(_module)
            })
        }
    }
    
    func dismiss(to: IRouter? = nil, _ completion: (() -> Void)? = nil) {
        if self.navigationController != nil {
            self.navigationController?.dismiss(animated: true, completion: {
                completion?()
                return
            })
            
            if let module = to?.module, let viewControllers = self.navigationController?.viewControllers {
                if let _vc = viewControllers.filter({ type(of: $0) == type(of: module) }).first {
                    self.navigationController?.popToViewController(_vc, animated: true)
                }
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            completion?()
        } else {
            self.dismiss(animated: true, completion: {
                completion?()
            })
        }
    }
    
    func backToRoot(_ completion: (() -> Void)? = nil) {
        self.navigationController?.popToRootViewController(animated: true)
        completion?()
    }
    
    static func newController(withView view: UIView, frame: CGRect) -> UIViewController {
        view.frame = frame
        let controller = UIViewController()
        controller.view = view
        return controller
    }
}

public extension UIWindow {
    struct TransitionOptions {
        public enum Curve {
            case linear
            case easeIn
            case easeOut
            case easeInOut
            
            internal var function: CAMediaTimingFunction {
                let key: String!
                switch self {
                case .linear: key = CAMediaTimingFunctionName.linear.rawValue
                case .easeIn: key = CAMediaTimingFunctionName.easeIn.rawValue
                case .easeOut: key = CAMediaTimingFunctionName.easeOut.rawValue
                case .easeInOut: key = CAMediaTimingFunctionName.easeInEaseOut.rawValue
                }
                return CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: key!))
            }
        }
        
        public enum Direction {
            case fade
            case toTop
            case toBottom
            case toLeft
            case toRight
            
            internal func transition() -> CATransition {
                let transition = CATransition()
                transition.type = CATransitionType.push
                switch self {
                case .fade:
                    transition.type = CATransitionType.fade
                    transition.subtype = nil
                case .toLeft:
                    transition.subtype = CATransitionSubtype.fromLeft
                case .toRight:
                    transition.subtype = CATransitionSubtype.fromRight
                case .toTop:
                    transition.subtype = CATransitionSubtype.fromTop
                case .toBottom:
                    transition.subtype = CATransitionSubtype.fromBottom
                }
                return transition
            }
        }
        
        public enum Background {
            case solidColor(_: UIColor)
            case customView(_: UIView)
        }
        
        public var duration: TimeInterval = 0.20
        public var direction: TransitionOptions.Direction = .toRight
        public var style: TransitionOptions.Curve = .linear
        public var background: TransitionOptions.Background?
        
        public init(direction: TransitionOptions.Direction = .toRight, style: TransitionOptions.Curve = .linear) {
            self.direction = direction
            self.style = style
        }
        
        public init() {}
        
        internal var animation: CATransition {
            let transition = self.direction.transition()
            transition.duration = self.duration
            transition.timingFunction = self.style.function
            return transition
        }
    }
    
    func setRootViewController(_ controller: UIViewController, options: TransitionOptions = TransitionOptions()) {
        var transitionWnd: UIWindow?
        if let background = options.background {
            transitionWnd = UIWindow(frame: UIScreen.main.bounds)
            switch background {
            case .customView(let view):
                transitionWnd?.rootViewController = UIViewController.newController(withView: view, frame: transitionWnd!.bounds)
            case .solidColor(let color):
                transitionWnd?.backgroundColor = color
            }
            transitionWnd?.makeKeyAndVisible()
        }
        
        self.layer.add(options.animation, forKey: kCATransition)
        self.rootViewController = controller
        self.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        
        if let wnd = transitionWnd {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1 + options.duration) {
                wnd.removeFromSuperview()
            }
        }
    }
}
