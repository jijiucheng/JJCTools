//
//  JJCSegmentView.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/8/2.
//

import UIKit

public class JJCSegmentView: UIView {
    /// Int - 最大 title 个数
    fileprivate let maxNum: Int = 5
    /// UIColor - 选中按钮底部横条 颜色
    fileprivate var selectedBottomViewColor = UIColor.clear
    /// CGFloat - 选中按钮底部横条 X
    fileprivate var selectedBottomViewX: CGFloat = 0
    /// CGFloat - 选中按钮底部横条 宽度
    fileprivate var selectedBottomViewW: CGFloat = 0
    /// CGFloat - 选中按钮底部横条 高度
    fileprivate var selectedBottomViewH: CGFloat = 0
    /// UIColor - normal 文字颜色
    fileprivate var titleColor: UIColor = .black
    /// UIFont - normal 文字大小
    fileprivate var titleFont: UIFont = UIFont.systemFont(ofSize: 16)
    /// UIColor - selected 文字颜色
    fileprivate var selectedTitleColor: UIColor = .black
    /// UIFont - selected 文字大小
    fileprivate var selectedTitleFont: UIFont = UIFont.systemFont(ofSize: 16)
    /// Array - 文字标题数组
    fileprivate var titles = [String]()
    
    /// UIScrollView - 按钮底部背景 ScrollView
    fileprivate var scrollView = UIScrollView()
    /// UIView - 选中按钮底部背景 View
    fileprivate lazy var selectedBgView = UIView()
    /// UIView - 选中按钮底部横条 View
    fileprivate lazy var selectedBottomView = UIView()
    /// UIButton - 上次选中的按钮
    fileprivate var lastSelectedBtn = UIButton(type: .custom)
    
    /// 按钮点击事件回调
    typealias ButtonActionBlock = (Int) -> Void
    var buttonActionBlock: ButtonActionBlock?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - UI
extension JJCSegmentView {
    /// UI
    fileprivate func setUI() {
        // UIView - 选中按钮底部横条 View
        selectedBottomView.frame = CGRect(x: 0, y: frame.size.height, width: 0, height: 0)
        addSubview(selectedBottomView)
    }
}

//MARK: - Methods
extension JJCSegmentView {
    /// Action - 核心方法
    public func setTitles(_ titles: [String], titleColor: UIColor, titleFont: UIFont, selectedTitleColor: UIColor, selectedTitleFont: UIFont) {
        // 缓存原始数据
        self.titles = titles
        self.titleColor = titleColor
        self.titleFont = titleFont
        self.selectedTitleColor = selectedTitleColor
        self.selectedTitleFont = selectedTitleFont
        
        // 移除所有子视图
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        setSelectedBottomViewParams(color: selectedBottomViewColor, width: selectedBottomViewW, height: selectedBottomViewH)
        // UIScrollView - 按钮底部背景 ScrollView
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - selectedBottomView.frame.size.height)
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        
        // 添加按钮
        var btnMaxWidth: CGFloat = 0
        for (index, title) in titles.enumerated() {
            var titleW = title.jjc_getContentSize(font: titleFont, contentMaxWH: titleFont.pointSize, isCalculateHeight: false).width + JJC_Margin * 2
            if frame.size.width > titleW * CGFloat(titles.count) {
                titleW = frame.size.width / CGFloat(titles.count)
            }
            
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: btnMaxWidth, y: 0, width: titleW, height: scrollView.frame.size.height)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(titleColor, for: .normal)
            btn.setTitleColor(selectedTitleColor, for: .selected)
            btn.titleLabel?.font = titleFont
            btn.tag = index
            btn.addTarget(self, action: #selector(btnAction(button:)), for: .touchUpInside)
            scrollView.addSubview(btn)
            
            if index == 0 {
                selectedBottomViewW = title.jjc_getContentSize(font: titleFont, contentMaxWH: titleFont.pointSize, isCalculateHeight: false).width
                selectedBottomViewX = (titleW - selectedBottomViewW) * 0.5
                selectedBottomView.frame = CGRect(x: selectedBottomViewX, y: selectedBottomView.frame.origin.y, width: selectedBottomViewW, height: selectedBottomView.frame.size.height)
                
                btn.isSelected = true
                btn.titleLabel?.font = selectedTitleFont
                lastSelectedBtn = btn
            }
            btnMaxWidth = btnMaxWidth + titleW
        }
    }
    
    /// Action - 选中按钮底部横条 View
    public func setSelectedBottomViewParams(color: UIColor, width: CGFloat, height: CGFloat) {
        selectedBottomViewColor = color
        selectedBottomViewW = selectedBottomViewW == 0 ? width : selectedBottomViewW
        selectedBottomViewH = height
        
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - selectedBottomViewH)
        selectedBottomView.frame = CGRect(x: selectedBottomViewX, y: frame.size.height - selectedBottomViewH, width: selectedBottomViewW, height: selectedBottomViewH)
        selectedBottomView.backgroundColor = color
    }
    
    /// Action - 更新标题
    public func updateTitles(_ titles: [String]) {
        for item in scrollView.subviews {
            if let button = item as? UIButton {
                button.setTitle(titles[button.tag], for: .normal)
            }
        }
    }
    
    /// Action - 按钮点击事件
    @objc fileprivate func btnAction(button: UIButton) {
        if lastSelectedBtn.tag != button.tag {
            lastSelectedBtn.isSelected = false
            lastSelectedBtn.setTitleColor(titleColor, for: .normal)
            lastSelectedBtn.titleLabel?.font = titleFont
            button.isSelected = true
            button.setTitleColor(selectedTitleColor, for: .selected)
            button.titleLabel?.font = selectedTitleFont
            
            selectedBottomViewW = titles[button.tag].jjc_getContentSize(font: titleFont, contentMaxWH: titleFont.pointSize, isCalculateHeight: false).width
            selectedBottomViewX = button.frame.origin.x + (button.frame.size.width - selectedBottomViewW) * 0.5
            
            UIView.animate(withDuration: 0.3) {
                self.selectedBottomView.frame = CGRect(x: self.selectedBottomViewX, y: self.selectedBottomView.frame.origin.y, width: self.selectedBottomViewW, height: self.selectedBottomView.frame.size.height)
            }
             
            lastSelectedBtn = button
        }
        if let buttonActionBlock = self.buttonActionBlock {
            buttonActionBlock(lastSelectedBtn.tag)
        }
    }
}
