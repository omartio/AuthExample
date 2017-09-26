//
//  AQButtonFilled.swift
//  aquavitalis
//
//  Created by Михаил Лукьянов on 23.08.17.
//  Copyright © 2017 Aqua Vitalis. All rights reserved.
//

import UIKit
import SnapKit

public class AEButton: UIButton {

    enum ButtonType {
        case filled
        case filledWithShadow
        case plain
    }
    
    enum State {
        case normal
        case active
        case success
    }
    
    let type: ButtonType
    
    init(type: ButtonType) {
        self.type = type
        super.init(frame: CGRect.zero)
        
        commonInit()
    }
    
    public override init(frame: CGRect) {
        self.type = .filled
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        type = .filled
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        switch type {
        case .filled, .filledWithShadow:
            backgroundColor = ThemeManager.mainColor
            setTitleColorWithHighlight(color: UIColor.white)
        case .plain:
            backgroundColor = UIColor.clear
            setTitleColorWithHighlight(color: ThemeManager.mainColor)
        }
        
        titleLabel?.font = ThemeManager.font(size: .medium)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if type == .filled || type == .filledWithShadow {
            self.makeCircleBorder()
        }
        if type == .filledWithShadow {
            self.applyHoverShadow(color: self.backgroundColor ?? UIColor.black)
        }
    }

    var preferredSize: CGSize {
        return CGSize(width: 147, height: 44)
    }
    
    // MARK: - State
    
    var activityState: State = .normal {
        didSet {
            self.updateState(activityState)
        }
    }
    
    private func updateState(_ state: State) {
        switch state {
        case .normal:
            showNormal()
        case .active:
            showActivity()
        case .success:
            showSuccess()
        }
    }
    
    private func showNormal() {
        activityIndicator?.setHiddenWithZoom(isHidden: true)
        activityIndicator?.stopAnimating()
        successImageView?.setHiddenWithZoom(isHidden: true)
        titleLabel?.animateAlpha(1)
    }
    
    private var activityIndicator: UIActivityIndicatorView?
    private func showActivity() {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
            switch type {
            case .filled, .filledWithShadow:
                activityIndicator?.color = UIColor.white
            case .plain:
                activityIndicator?.color = ThemeManager.secondForegroundColor
            }
            addSubview(activityIndicator!)
            activityIndicator?.snp.makeConstraints({ (make) in
                make.center.equalTo(self)
            })
        }
        
        activityIndicator!.startAnimating()
        activityIndicator!.isHidden = true
        activityIndicator!.setHiddenWithZoom(isHidden: false)
        titleLabel?.animateAlpha(0)
    }
    
    private var successImageView: UIImageView?
    private func showSuccess() {
        if successImageView == nil {
            successImageView = UIImageView(image: #imageLiteral(resourceName: "checked"))
            switch type {
            case .filled, .filledWithShadow:
                successImageView?.tintColor = UIColor.white
            case .plain:
                successImageView?.tintColor = ThemeManager.secondColor
            }
            successImageView!.contentMode = .center
            successImageView!.isHidden = true
            addSubview(successImageView!)
            successImageView!.snp.makeConstraints { (make) in
                make.edges.equalTo(self)
            }
        }
        successImageView!.isHidden = true
        successImageView!.setHiddenWithZoom(isHidden: false)
        
        activityIndicator?.setHiddenWithZoom(isHidden: true)
        activityIndicator?.stopAnimating()
        titleLabel?.animateAlpha(0)
    }
    
    public func showSuccesAutoHide() {
        activityState = .success
        delayWithSeconds(2) {
            self.activityState = .normal
        }
    }
    
}

public class AEButtonFilled: AEButton {
    
    init() {
        super.init(type: .filled)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
