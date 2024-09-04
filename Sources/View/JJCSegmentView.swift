//
//  JJCSegmentView.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/8/2.
//

import UIKit

/// 核心 Item 参数（背景色、文字颜色、文字大小）
public typealias JJCSegmentItemParams = (bgColor: UIColor, titleColor: UIColor, titleFont: UIFont)
/// 核心线条参数（颜色、宽度、高度、宽度是否固定）
public typealias JJCSegmentLineParams = (color: UIColor, width: CGFloat, height: CGFloat, isFixed: Bool)
/// 核心选中 Item 参数（颜色、宽度、高度、圆角、宽度是否固定）
public typealias JJCSegmentSelectedBgParams = (color: UIColor, width: CGFloat, height: CGFloat, radius: CGFloat, isFixed: Bool)

/// 展示类型
public enum JJCSegmentType: Int {
    case none = -1          // 不设定任何类型
    case dynamic = 0        // 动态宽度，默认
    case fixed              // 固定宽度
    case equal              // 相等宽度，适用于不超出容器宽度
    case compatible         // 兼容模式，分开计算不超出和超出容器宽度场景
}

/// 展示位置
public enum JJCSegmentAlignment: Int {
    case none = -1          // 不设定任何类型
    case left = 0           // 居左，默认
    case center             // 居中
    case right              // 局右
}

/// 选中类型
public enum JJCSegmentSelectedType: Int {
    case none = -1          // 不设定任何类型
    case line = 0           // 底部线条
    case textBgColor        // 文字背景颜色
    case itemBgColor        // 按钮背景颜色
}

public class JJCSegmentView: UIView {
    /// 展示类型
    public var type: JJCSegmentType = .dynamic
    public var inType: JJCSegmentType = .none
    public var outType: JJCSegmentType = .none
    /// 展示位置
    public var alignment: JJCSegmentAlignment = .left
    public var inAlignment: JJCSegmentAlignment = .none
    public var outAlignment: JJCSegmentAlignment = .none
    /// 文字标题数组（默认、选中，其中选中状态标题可以单独设置，如果不单独设置则和默认保持一致）
    public var titles = [String]()
    public var selectedTitles = [(title: String, index: Int)]()
    /// 最大显示 title 个数
    public var displayMaxNum: Int = 5
    /// 按钮宽度（仅在 type = fixed 时有效）
    public var itemWidth: CGFloat = 50
    /// 按钮最小宽度
    public var minItemWidth: CGFloat = 40
    /// 两个按钮间距
    public var itemSpace: CGFloat = JJC_Margin * 2
    /// 选中类型
    public var selectedType: JJCSegmentSelectedType = .line
    /// 当前选中 index
    public var selectIndex: Int = 0
    /// 默认状态下参数（背景色、文字颜色、文字大小）
    public var normalParams: JJCSegmentItemParams = (.clear, JJC_ThemeColor(.subTitle), .systemFont(ofSize: 14))
    /// 选中状态下参数（背景色、文字颜色、文字大小）
    public var selectedParams: JJCSegmentItemParams = (.clear, JJC_ThemeColor(.mainTitle), .systemFont(ofSize: 16, weight: .medium))
    /// 线条参数（颜色、宽度、高度、宽度是否固定）
    public var lineVParams: JJCSegmentLineParams = (.orange, 40, 2, false)
    /// 核心选中 Item 参数（颜色、宽度、高度、圆角、宽度是否固定）
    public var selectedBgParams: JJCSegmentSelectedBgParams = (.orange, 40, 30, 10, false)
    
    /// 按钮底部背景 ScrollView
    fileprivate var scrollView = UIScrollView()
    /// 线条
    fileprivate var lineV = UIView()
    /// 选中背景颜色
    fileprivate var selectedBgV = UIView()
    /// 上次选中的按钮
    fileprivate var lastSelectedBtn = UIButton(type: .custom)
    
    /// 按钮点击事件回调
    public var clickBlock: ((Int, String, String) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - 核心方法
extension JJCSegmentView {
    /// 核心方法
    fileprivate func setUI() {
        // 调整显示选中类型及参数数据的合理性
        lineV.isHidden = true
        selectedBgV.isHidden = true
        if selectedType == .line {
            lineV.isHidden = false
            lineV.backgroundColor = lineVParams.color
            lineVParams.height = min(lineVParams.height, frame.size.height * 0.5)
        } else if selectedType == .textBgColor || selectedType == .itemBgColor {
            lineVParams.height = 0
            selectedBgV.isHidden = false
            selectedBgV.backgroundColor = selectedBgParams.color
            selectedBgParams.height = min(selectedBgParams.height, frame.size.height - JJC_Margin)
            if selectedType == .itemBgColor {
                selectedBgParams.height = frame.size.height
            }
            selectedBgParams.radius = min(selectedBgParams.radius, selectedBgParams.height * 0.5)
        }
        
        // 移除所有子视图
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        scrollView.frame = self.bounds
        scrollView.addSubview(lineV)
        scrollView.addSubview(selectedBgV)
        // 添加按钮
        var btnMaxWidth: CGFloat = 0
        for (index, title) in titles.enumerated() {
            // 计算默认状态和选中状态文本
            var selectedTitle = ""
            for selectedItem in selectedTitles where selectedItem.index == index {
                selectedTitle = selectedItem.title
            }
            if selectedTitle.jjc_isEmptyOrInvalid() {
                selectedTitle = title
            }
            // 动态计算宽度
            var titleW = title.jjc_getContentSize(font: normalParams.titleFont, contentMaxWH: frame.size.width * 0.5, isCalculateHeight: false).width + itemSpace * 0.5 * 2
            let selectedTitleW = selectedTitle.jjc_getContentSize(font: selectedParams.titleFont, contentMaxWH: frame.size.width * 0.5, isCalculateHeight: false).width + itemSpace * 0.5 * 2
            titleW = max(titleW, selectedTitleW)
            titleW = max(titleW, minItemWidth)
            titleW = min(titleW, frame.size.width * 0.5)
            // 根据类型调整宽度
            switch type {
            case .fixed: titleW = itemWidth
            case .equal: titleW = frame.size.width / CGFloat(min(titles.count, displayMaxNum))
            default: break
            }
            
            // 创建按钮
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: btnMaxWidth, y: 0, width: titleW, height: scrollView.frame.size.height - lineVParams.height)
            btn.backgroundColor = normalParams.bgColor
            btn.jjc_params(title: title, titleColor: normalParams.titleColor, font: normalParams.titleFont, state: .normal)
            btn.jjc_params(title: selectedTitle, titleColor: selectedParams.titleColor, font: normalParams.titleFont, state: .selected)
            btn.tag = index
            btn.isSelected = false
            btn.addTarget(self, action: #selector(btnAction(button:)), for: .touchUpInside)
            scrollView.addSubview(btn)
            
            if index == selectIndex {
                btn.isSelected = true
                btn.backgroundColor = selectedParams.bgColor
                btn.titleLabel?.font = selectedParams.titleFont
                lastSelectedBtn = btn
                
                let lineVW = lineVParams.isFixed ? lineVParams.width : titleW
                let lineVH = lineVParams.height
                let lineVX = lastSelectedBtn.frame.origin.x + (lastSelectedBtn.frame.size.width - lineVW) * 0.5
                let lineVY = lastSelectedBtn.frame.origin.y + lastSelectedBtn.frame.size.height
                lineV.frame = CGRect(x: lineVX, y: lineVY, width: lineVW, height: lineVH)
                lineV.jjc_radius(radius: lineVH * 0.5)
                
                let selectedBgVW = selectedBgParams.isFixed ? selectedBgParams.width : (selectedType == .itemBgColor ? lastSelectedBtn.frame.size.width : titleW)
                let selectedBgVH = selectedBgParams.height
                let selectedBgVX = lastSelectedBtn.frame.origin.x + (selectedType == .itemBgColor ? 0 : (lastSelectedBtn.frame.size.width - titleW) * 0.5)
                let selectedBgVY = selectedType == .itemBgColor ? 0 : (frame.size.height - selectedBgParams.height) * 0.5
                let radius = min(selectedBgVH * 0.5, selectedBgParams.radius)
                selectedBgV.frame = CGRect(x: selectedBgVX, y: selectedBgVY, width: selectedBgVW, height: selectedBgVH)
                selectedBgV.jjc_radius(radius: radius)
            }
            btnMaxWidth = btnMaxWidth + titleW
        }
        scrollView.contentSize = CGSizeMake(btnMaxWidth, scrollView.frame.size.height)
    }
}

// MARK: - Methods
extension JJCSegmentView {
    /// Action - 开始渲染（需要在所有参数配置完成后调用，或有参数更新后调用）
    public func jjc_update() {
        guard frame.size.width > 0 && frame.size.height > 0 else { return }
        setUI()
    }
    
    /// Action - 按钮点击事件
    @objc fileprivate func btnAction(button: UIButton) {
        if lastSelectedBtn.tag != button.tag {
            // 更新选中
            lastSelectedBtn.isSelected = false
            lastSelectedBtn.backgroundColor = normalParams.bgColor
            lastSelectedBtn.titleLabel?.font = normalParams.titleFont
            button.isSelected = true
            button.backgroundColor = selectedParams.bgColor
            button.titleLabel?.font = selectedParams.titleFont
            lastSelectedBtn = button
            
            // 动画效果
            let selectedTitle = lastSelectedBtn.title(for: .selected) ?? ""
            let titleW = selectedTitle.jjc_getContentSize(font: selectedParams.titleFont, contentMaxWH: frame.size.width * 0.5, isCalculateHeight: false).width + JJC_Margin
            
            let lineVW = lineVParams.isFixed ? lineVParams.width : titleW
            let lineVH = lineVParams.height
            let lineVX = lastSelectedBtn.frame.origin.x + (lastSelectedBtn.frame.size.width - lineVW) * 0.5
            let lineVY = lastSelectedBtn.frame.origin.y + lastSelectedBtn.frame.size.height
            
            let selectedBgVW = selectedBgParams.isFixed ? selectedBgParams.width : (selectedType == .itemBgColor ? lastSelectedBtn.frame.size.width : titleW)
            let selectedBgVH = selectedBgParams.height
            let selectedBgVX = lastSelectedBtn.frame.origin.x + (selectedType == .itemBgColor ? 0 : (lastSelectedBtn.frame.size.width - titleW) * 0.5)
            let selectedBgVY = selectedType == .itemBgColor ? 0 : (frame.size.height - selectedBgParams.height) * 0.5
            
            let btnX = lastSelectedBtn.frame.origin.x
            let btnW = lastSelectedBtn.frame.size.width
            let scrollContentW = scrollView.contentSize.width
            let containerStartX = (frame.size.width - btnW) * 0.5
            var offsetX: CGFloat = 0
            if btnX > containerStartX {
                offsetX = btnX - containerStartX
            }
            if btnX > scrollContentW - containerStartX - btnW {
                offsetX = scrollContentW - frame.size.width
            }
            
            UIView.animate(withDuration: 0.3) {
                self.lineV.frame = CGRect(x: lineVX, y: lineVY, width: lineVW, height: lineVH)
                self.selectedBgV.frame = CGRect(x: selectedBgVX, y: selectedBgVY, width: selectedBgVW, height: selectedBgVH)
                self.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
            }
        }
        clickBlock?(lastSelectedBtn.tag, titles[lastSelectedBtn.tag], lastSelectedBtn.titleLabel?.text ?? "")
    }
}
