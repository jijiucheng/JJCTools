//
//  JJCAlertController.swift
//  JJCTools
//
//  Created by mxgx on 2024/6/14.
//

import UIKit

@MainActor
public class JJCAlertController: UIViewController {
    /// JJCAlertController - 白色底部背景
    public lazy var containerView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// JJCAlertController - 主标题
    public lazy var mainTitleLabel = {
        let label = UILabel()
        label.text = JJC_Local("Tips", "温馨提示")
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// JJCAlertController - 副标题
    public lazy var subTitleLabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// JJCAlertController - 取消按钮
    public lazy var cancelBtn = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .lightGray
        btn.setTitle(JJC_Local("Cancel", "取消"), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    /// JJCAlertController - 确定按钮
    public lazy var confirmBtn = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .lightGray
        btn.setTitle(JJC_Local("Confirm", "确定"), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    /// JJCAlertController - 内容容器
    public lazy var contentScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.showsVerticalScrollIndicator = true
        view.contentInsetAdjustmentBehavior = .never
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// JJCAlertController - 内容
    public lazy var contentLabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var containerHorizontalMargin: CGFloat = 30
    public var containerVerticalMargin: CGFloat = 70
    public var buttonWidth: CGFloat? = nil
    public var buttonHeight: CGFloat = 40
    /// JJCAlertController - 确定按钮是否居中（只在取消按钮隐藏的情况下有效）
    public var confirmIsCenter: Bool = false
    public var content: String = ""
    
    /// JJCAlertController - 点击事件回调
    public var clickBlock: ((_ isConfirm: Bool) -> Void)?
    public var clickBlockByDismiss: ((_ isConfirm: Bool) -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension JJCAlertController {
    /// JJCAlertController - 添加控件
    fileprivate func setUI() {
        view.addSubview(containerView)
        containerView.addSubview(mainTitleLabel)
        containerView.addSubview(subTitleLabel)
        containerView.addSubview(cancelBtn)
        containerView.addSubview(confirmBtn)
        containerView.addSubview(contentScrollView)
        contentScrollView.addSubview(contentLabel)
    }
    
    /// JJCAlertController - 配置完成，所有的参数配置需要在调用该方法之前完成
    public func setConfigFinished() {
        contentLabel.text = content
        layoutUI()
    }
    
    fileprivate func layoutUI() {
        let containerWidth: CGFloat = view.frame.size.width - containerHorizontalMargin * 2
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: containerWidth)
        ])
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: JJC_Margin * 2),
            mainTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: JJC_Margin * 2),
            mainTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -JJC_Margin * 2)
        ])
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: mainTitleLabel.trailingAnchor),
            subTitleLabel.heightAnchor.constraint(equalToConstant: subTitleLabel.isHidden ? 0 : JJC_Margin * 2)
        ])
        NSLayoutConstraint.activate([
            cancelBtn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -JJC_Margin),
            cancelBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -containerWidth * 0.25),
            cancelBtn.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        NSLayoutConstraint.activate([
            confirmBtn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -JJC_Margin),
            confirmBtn.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
        if cancelBtn.isHidden && confirmIsCenter {
            NSLayoutConstraint.activate([
                confirmBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                confirmBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: containerWidth * 0.25)
            ])
        }
        if let tempButtonWidth = buttonWidth {
            NSLayoutConstraint.activate([
                cancelBtn.widthAnchor.constraint(equalToConstant: tempButtonWidth),
                confirmBtn.widthAnchor.constraint(equalToConstant: tempButtonWidth)
            ])
        } else {
            NSLayoutConstraint.activate([
                cancelBtn.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.25),
                confirmBtn.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.25)
            ])
        }
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: JJC_Margin * 2),
            contentScrollView.leadingAnchor.constraint(equalTo: mainTitleLabel.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: mainTitleLabel.trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: confirmBtn.topAnchor, constant: -JJC_Margin * 2)
        ])
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentLabel.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor)
        ])
        
        // 计算 UIScrollView 的高度
        contentLabel.superview?.layoutIfNeeded()
        var size = contentLabel.sizeThatFits(CGSize(width: contentScrollView.frame.width, height: .greatestFiniteMagnitude))
        let maxHeight = view.frame.size.height - containerVerticalMargin * 2 - buttonHeight - JJC_Margin * 7
        if size.height < 30 {
            size.height = 30
        } else if size.height > maxHeight {
            size.height = maxHeight
        }
        NSLayoutConstraint.activate([
            contentScrollView.heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
}

extension JJCAlertController {
    /// JJCAlertController - 取消按钮点击事件
    @objc fileprivate func cancelBtnAction() {
        if let clickBlock = self.clickBlock {
            clickBlock(false)
        } else {
            dismiss(animated: true) {
                self.clickBlock?(false)
            }
        }
    }
    
    /// JJCAlertController - 确定按钮点击事件
    @objc fileprivate func confirmBtnAction() {
        if let clickBlock = self.clickBlock {
            clickBlock(true)
        } else {
            dismiss(animated: true) {
                self.clickBlock?(true)
            }
        }
    }
}
