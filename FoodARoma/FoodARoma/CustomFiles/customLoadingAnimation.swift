//
//  customLoadingAnimation.swift
//  FoodARoma
//
//  Created by alan on 2023-06-22.
//

import UIKit
import NVActivityIndicatorView


extension UIViewController {
    
//    --------------------------------- usage ---------------------------------
//    import NVActivityIndicatorView
//    var loading : (NVActivityIndicatorView,UIView)? ------ as in class file
//    loading = customAnimation()  --- when u want to start loading
//    loadingProtocol(with: loading! ,true)  --- above same time
//    loadingProtocol(with: loading! ,false) --- to stop loading
    
    //MARK: custom loadng view
    func customAnimation() -> (NVActivityIndicatorView,UIView){
    
    let parentView : UIView = {
        let myView = UIView()
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.60)
        return myView
    }()
    let actualAnimationView : NVActivityIndicatorView = {
        let myView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 70),type: .semiCircleSpin, color: UIColor.orange)
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()
    
    view.addSubview(parentView)
    parentView.addSubview(actualAnimationView)
    
    var constr = [NSLayoutConstraint]()
    constr.append(parentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
    constr.append(parentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        constr.append(parentView.bottomAnchor.constraint(equalTo: view.superview!.bottomAnchor))
    constr.append(parentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
    
    constr.append(actualAnimationView.heightAnchor.constraint(equalToConstant: 60))
    constr.append(actualAnimationView.widthAnchor.constraint(equalToConstant: 60))
    constr.append(actualAnimationView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor))
    constr.append(actualAnimationView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor))

    NSLayoutConstraint.activate(constr)
    
    return (actualAnimationView,parentView)
}
    
    func loadingProtocol(with : (NVActivityIndicatorView,UIView),_ status : Bool){
        if status {
            with.0.startAnimating()
            with.1.isHidden = false
            with.1.alpha = 1
        }
        else{
            with.0.stopAnimating()
            with.1.isHidden = true
        }
    }
    
    //MARK: tableView Loading
    func createView(table : UITableView) -> UIView{
        let footerView = UIView(frame: CGRect(x: 0,y: 0,width: table.frame.width,height: 50))
        footerView.backgroundColor = .clear
        let loadingItem = UIActivityIndicatorView()
        loadingItem.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(loadingItem)
        loadingItem.color = .black
        loadingItem.startAnimating()
       
        
        var constr = [NSLayoutConstraint]()
        constr.append(loadingItem.heightAnchor.constraint(equalToConstant: 40))
        constr.append(loadingItem.widthAnchor.constraint(equalToConstant: 40))
        constr.append(loadingItem.centerXAnchor.constraint(equalTo: footerView.centerXAnchor))
        constr.append(loadingItem.centerYAnchor.constraint(equalTo: footerView.centerYAnchor))
        NSLayoutConstraint.activate(constr)
        
        return footerView
    }
    
    func tableviewLastCellLoading (table : UITableView, start : Bool = true){
        
        if start {
            let view = createView(table: table)
            table.tableFooterView = view
        }
        else{
            table.tableFooterView = nil
        }
    }
    
}
