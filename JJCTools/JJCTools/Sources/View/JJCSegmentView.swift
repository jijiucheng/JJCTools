//
//  JJCSegmentView.swift
//  JJCSwiftTools
//
//  Created by mxgx on 2021/8/2.
//

import UIKit

public enum JJCSegmentType: Int {
    case `default` = 0      // 默认配置（动态宽度）
    case fixed              // 固定宽度
    case compatible         // 设定了默认最大个数，当小于最大个数时等宽显示，超过则动态宽度显示
}

public enum JJCSegmentSelectedType: Int {
    case line = 0           // 底部线条
    case textBgColor        // 文字背景颜色
    case itemBgColor        // 按钮背景颜色
}

public class JJCSegmentView: UIView {
    /// JJCSegmentType - 展示类型
    public var type: JJCSegmentType = .default
    /// JJCSegmentSelectedType - 选中类型
    public var selectedType: JJCSegmentSelectedType = .line
    /// 元组 - 默认状态下参数（背景色、文字颜色、文字大小）
    public var normalParams: (bgColor: UIColor, titleColor: UIColor, titleFont: UIFont) = (.clear, JJCTheme.shared.jjc_color_subTitle(), .systemFont(ofSize: 14))
    /// 元组 - 选中状态下参数（背景色、文字颜色、文字大小）
    public var selectedParams: (bgColor: UIColor, titleColor: UIColor, titleFont: UIFont) = (.clear, JJCTheme.shared.jjc_color_mainTitle(), .systemFont(ofSize: 16, weight: .medium))
    /// 元组 - 线条参数（颜色、宽度、高度、宽度是否固定）
    public var lineVParams: (color: UIColor, width: CGFloat, height: CGFloat, isFixed: Bool) = (.orange, 40, 2, false)
    /// 元组 - 选中背景颜色参数（颜色、宽度、高度、宽度是否固定）
    public var bgColorVParams: (color: UIColor, width: CGFloat, height: CGFloat, radius: CGFloat, isFixed: Bool) = (.orange, 40, 30, 10, false)
    /// Array - 文字标题数组（默认、选中）
    public var titles = [[String]]()
    /// Int - 最大 title 个数
    public var maxNum: Int = 5
    /// CGFloat - 按钮宽度（仅在 type = fixed 时有效）
    public var itemWidth: CGFloat = 50
    /// CGFloat - 两个按钮间距
    public var itemSpace: CGFloat = JJC_Margin * 2
    
    /// UIScrollView - 按钮底部背景 ScrollView
    fileprivate var scrollView = UIScrollView()
    /// UIView - 线条
    fileprivate var lineV = UIView()
    /// UIView - 选中背景颜色
    fileprivate var bgColorV = UIView()
    /// UIButton - 上次选中的按钮
    fileprivate var lastSelectedBtn = UIButton(type: .custom)
    
    /// 按钮点击事件回调
    public var clickBlock: ((Int, String, String) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(lineV)
        addSubview(bgColorV)
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
        switch selectedType {
        case .line:
            lineV.isHidden = false
            bgColorV.isHidden = true
            lineVParams.height = lineVParams.height > frame.size.height * 0.5 ? frame.size.height * 0.5 : lineVParams.height
            lineV.backgroundColor = lineVParams.color
        case .textBgColor, .itemBgColor:
            lineV.isHidden = true
            bgColorV.isHidden = false
            lineVParams.height = 0
            bgColorVParams.height = selectedType == .itemBgColor ? frame.size.height : (bgColorVParams.height > (frame.size.height - JJC_Margin) ? (frame.size.height - JJC_Margin) : bgColorVParams.height)
            bgColorVParams.radius = bgColorVParams.radius > bgColorVParams.height ? bgColorVParams.height : bgColorVParams.radius
            bgColorV.backgroundColor = bgColorVParams.color
        }
        
        // 移除所有子视图
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        // 设置 ScrollView
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height - lineVParams.height)
        scrollView.showsHorizontalScrollIndicator = false
        
        if let firstTitles = titles.first {
            // 调整标题数组
            var lastTitles: [String] = []
            if let tempTitles = titles.last {
                for (index, title) in firstTitles.enumerated() {
                    lastTitles.append(index < tempTitles.count ? tempTitles[index] : title)
                }
            } else {
                lastTitles = firstTitles
            }
            titles = [firstTitles, lastTitles]
            
            // 添加按钮
            var btnMaxWidth: CGFloat = 0
            for (index, title) in firstTitles.enumerated() {
                // 计算宽度
                var titleW = title.jjc_getContentSize(font: normalParams.titleFont, contentMaxWH: frame.size.width * 0.5, isCalculateHeight: false).width + itemSpace * 0.5 * 2
                titleW = titleW < 40 ? 40 : titleW
                titleW = titleW > frame.size.width * 0.5 ? frame.size.width * 0.5 : titleW
                // 根据类型调整宽度
                switch type {
                case .fixed:  titleW = firstTitles.count > maxNum ? itemWidth : frame.size.width / CGFloat(firstTitles.count)
                case .compatible: titleW = firstTitles.count > maxNum ? titleW : frame.size.width / CGFloat(firstTitles.count)
                default: break
                }
                
                // 创建按钮
                let btn = UIButton(type: .custom)
                btn.frame = CGRect(x: btnMaxWidth, y: 0, width: titleW, height: scrollView.frame.size.height)
                btn.backgroundColor = normalParams.bgColor
                btn.jjc_params(title: title, titleColor: normalParams.titleColor, font: normalParams.titleFont, state: .normal)
                btn.jjc_params(title: lastTitles[index], titleColor: selectedParams.titleColor, font: normalParams.titleFont, state: .selected)
                btn.tag = index
                btn.isSelected = false
                btn.addTarget(self, action: #selector(btnAction(button:)), for: .touchUpInside)
                scrollView.addSubview(btn)
                
                // 标记选中
                if index == lastSelectedBtn.tag {
                    btn.isSelected = true
                    btn.backgroundColor = selectedParams.bgColor
                    btn.titleLabel?.font = selectedParams.titleFont
                    lastSelectedBtn = btn
                    
                    let titleW = lastTitles[lastSelectedBtn.tag].jjc_getContentSize(font: selectedParams.titleFont, contentMaxWH: frame.size.width * 0.5, isCalculateHeight: false).width + JJC_Margin
        
                    let lineVX = lastSelectedBtn.frame.origin.x + (lastSelectedBtn.frame.size.width - titleW) * 0.5
                    let lineVY = lastSelectedBtn.frame.origin.y + lastSelectedBtn.frame.size.height
                    lineVParams.width = lineVParams.isFixed ? lineVParams.width : titleW
                    lineV.frame = CGRect(x: lineVX, y: lineVY, width: lineVParams.width, height: lineVParams.height)
                    lineV.jjc_radius(radius: lineVParams.height * 0.5)
                    
                    let bgColorVX = lastSelectedBtn.frame.origin.x + (selectedType == .itemBgColor ? 0 : (lastSelectedBtn.frame.size.width - titleW) * 0.5)
                    let bgColorVY = selectedType == .itemBgColor ? 0 : (frame.size.height - bgColorVParams.height) * 0.5
                    bgColorVParams.width = bgColorVParams.isFixed ? bgColorVParams.width : (selectedType == .itemBgColor ? lastSelectedBtn.frame.size.width : titleW)
                    bgColorV.frame = CGRect(x: bgColorVX, y: bgColorVY, width: bgColorVParams.width, height: bgColorVParams.height)
                    bgColorV.jjc_radius(radius: (bgColorVParams.radius > bgColorVParams.height ? bgColorVParams.height : bgColorVParams.radius))
                }
                btnMaxWidth = btnMaxWidth + titleW
            }
        }
    }
}

// MARK: - Methods
extension JJCSegmentView {
    /// Action - 开始渲染（需要在所有参数配置完成后调用，或有参数更新后调用）
    public func jjc_update() {
        setUI()
    }
    
    /// Action - 按钮点击事件
    @objc fileprivate func btnAction(button: UIButton) {
        if lastSelectedBtn.tag != button.tag {
            lastSelectedBtn.isSelected = false
            lastSelectedBtn.backgroundColor = normalParams.bgColor
            lastSelectedBtn.titleLabel?.font = normalParams.titleFont
            button.isSelected = true
            button.backgroundColor = selectedParams.bgColor
            button.titleLabel?.font = selectedParams.titleFont
            lastSelectedBtn = button
            
            // 动画效果
            if let lastTitles = titles.last, lastTitles.count > lastSelectedBtn.tag {
                let title = lastTitles[lastSelectedBtn.tag]
                let titleW = title.jjc_getContentSize(font: selectedParams.titleFont, contentMaxWH: frame.size.width * 0.5, isCalculateHeight: false).width + JJC_Margin
                
                let lineVX = lastSelectedBtn.frame.origin.x + (lastSelectedBtn.frame.size.width - titleW) * 0.5
                let lineVY = lastSelectedBtn.frame.origin.y + lastSelectedBtn.frame.size.height
                lineVParams.width = lineVParams.isFixed ? lineVParams.width : titleW
                
                let bgColorVX = lastSelectedBtn.frame.origin.x + (selectedType == .itemBgColor ? 0 : (lastSelectedBtn.frame.size.width - titleW) * 0.5)
                let bgColorVY = selectedType == .itemBgColor ? 0 : (frame.size.height - bgColorVParams.height) * 0.5
                bgColorVParams.width = bgColorVParams.isFixed ? bgColorVParams.width : (selectedType == .itemBgColor ? lastSelectedBtn.frame.size.width : titleW)
                
                UIView.animate(withDuration: 0.3) {
                    self.lineV.frame = CGRect(x: lineVX, y: lineVY, width: self.lineVParams.width, height: self.lineVParams.height)
                    self.bgColorV.frame = CGRect(x: bgColorVX, y: bgColorVY, width: self.bgColorVParams.width, height: self.bgColorVParams.height)
                }
            }
        }
        if let firstTitles = titles.first, firstTitles.count > lastSelectedBtn.tag,
            let lastTitles = titles.last, lastTitles.count > lastSelectedBtn.tag {
            if let clickBlock = self.clickBlock {
                clickBlock(lastSelectedBtn.tag, firstTitles[lastSelectedBtn.tag], lastTitles[lastSelectedBtn.tag])
            }
        }
    }
}
