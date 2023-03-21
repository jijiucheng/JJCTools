//
//  JJCHUD.swift
//  JJCTools
//
//  Created by mxgx on 2023/3/21.
//

import UIKit

public enum JJCHUDType: Int {
    case message = 0        // 纯消息
    case success            // 成功
    case failure            // 失败
    case loading            // 加载中
    case progress           // 进度
}

public enum JJCHUDAlignment: Int {
    case center = 0         // 居中
    case top                // 顶部
    case bottom             // 底部
    case left               // 左侧
    case right              // 右侧
    case topLeft            // 左上角
    case topRight           // 右上角
    case bottomLeft         // 左下角
    case bottomRight        // 右下角
}

public class JJCHUD: UIView {
    /// 背景框宽度
    fileprivate var containerVW: CGFloat = JJC_IPhone6sRatio(240)
    /// 背景框高度
    fileprivate var containerVH: CGFloat = JJC_IPhone6sRatio(240)
    /// 图标宽高
    fileprivate var iconImgVWH: CGFloat = JJC_IPhone6sRatio(100)
    /// 文本顶部间距
    fileprivate var contentTop: CGFloat = JJC_IPhone6sRatio(40) + JJC_IPhone6sRatio(100) + JJC_IPhone6sRatio(24)
    /// 默认显示隐藏动画时间
    fileprivate let defaultAnimateTime: Double = 0.3
    /// 设置超时时长，超时后默认会隐藏
    fileprivate let defaultOutTime: Double = 15
    /// 当前显示个数
    fileprivate var showCount: Int = 0
    /// 添加定时器
    fileprivate var timer: DispatchSourceTimer?
    /// 当前定时器时长
    fileprivate var timeCount: Double = 0
    
    /// 当前类型
    fileprivate var type: JJCHUDType = .message
    /// 文本内容
    fileprivate var content: String?
    
    /// 蒙层背景
    private lazy var maskBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 1
        return view
    }()
    /// 背景
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    /// 图标
    private lazy var iconImgView: UIImageView = {
        let imageV = UIImageView(image: JJC_Image("base_hud_success"))
        imageV.contentMode = .scaleAspectFit
        imageV.isHidden = true
        return imageV
    }()
    /// 进度
    private lazy var progressView: JJCHUDProgressView = {
        let view = JJCHUDProgressView()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    /// 文本内容
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 定时器
extension JJCHUD {
    /// 添加定时器
    fileprivate func startTimer(_ type: JJCHUDType) {
        // 开启定时器前先移除之前的定时器
        stopTimer()
        // 计算各类型的 HUD 默认显示时长
        var timeMax: Double = 1
        switch type {
        case .message: timeMax = 1.5
        case .success: timeMax = 1
        case .failure: timeMax = 1
        case .loading: timeMax = defaultOutTime
        case .progress: timeMax = defaultOutTime
        }
        
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer?.schedule(deadline: .now(), repeating: 0.5, leeway: .nanoseconds(1))
        timer?.setRegistrationHandler(handler: {
            self.timeCount = 0
        })
        timer?.setEventHandler(handler: {
            if self.timeCount >= timeMax {
                self.hide(true, delay: 0) {
                    self.stopTimer()
                }
            }
            self.timeCount += 0.5
        })
        timer?.resume()
    }
    
    /// 销毁定时器
    fileprivate func stopTimer() {
        if let timer = self.timer {
            timer.cancel()
        }
        timer = nil
    }
}

//MARK: - 显示、隐藏
extension JJCHUD {
    /// 显示
    public class func show(_ view: UIView, animate: Bool = true) -> JJCHUD {
        return JJCHUD().show(view, animate: animate)
    }
    
    fileprivate func show(_ view: UIView, animate: Bool = true) -> JJCHUD {
        frame = view.bounds
        view.addSubview(self)
        show(animate)
        return self
    }
    
    public func show(_ animate: Bool = true) {
        superview?.subviews.forEach({
            if let hud = $0 as? JJCHUD, self != hud {
                hud.stopTimer()
                hud.removeFromSuperview()
            }
        })
        DispatchQueue.main.async {
            if self.showCount > 0 {
                self.hide(false, delay: 0) {
                    self.showCount += 1
                    self.maskBgView.alpha = 0
                    UIView.animate(withDuration: animate ? self.defaultAnimateTime : 0) {
                        self.maskBgView.alpha = 1
                    }
                }
            } else {
                self.showCount += 1
                self.maskBgView.alpha = 0
                UIView.animate(withDuration: animate ? self.defaultAnimateTime : 0) {
                    self.maskBgView.alpha = 1
                }
            }
        }
    }
    
    /// 隐藏
    public class func hide(_ view: UIView, animate: Bool = true, delay: Double = 0, completion: (() -> Void)? = nil) {
        JJCHUD().hide(view, animate: animate, delay: delay, completion: completion)
    }
    
    fileprivate func hide(_ view: UIView, animate: Bool = true, delay: Double = 0, completion: (() -> Void)? = nil) {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            DispatchQueue.main.async {
                for subView in view.subviews.reversed() where subView is JJCHUD {
                    if let hud = subView as? JJCHUD {
                        hud.hide(animate, delay: 0, completion: completion)
                        return
                    }
                }
            }
        }
    }
    
    public func hide(_ animate: Bool = true, delay: Double = 0, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.showCount -= 1
            self.maskBgView.alpha = 1
            UIView.animate(withDuration: animate ? self.defaultAnimateTime : 0, delay: delay, options: []) {
                self.maskBgView.alpha = 0
            } completion: { _ in
                self.removeFromSuperview()
                completion?()
            }
        }
    }
    
    /// 根据类型设置默认隐藏时间
    func hideByDefault(_ completion: (() -> Void)? = nil) {
        switch type {
        case .message: hide(delay: 1.5, completion: completion)
        case .success: hide(delay: 1, completion: completion)
        case .failure: hide(delay: 1, completion: completion)
        case .loading: hide(delay: defaultOutTime, completion: completion)
        case .progress: hide(delay: defaultOutTime, completion: completion)
        }
    }
}

//MARK: - 配置、约束、类型
extension JJCHUD {
    /// 添加子视图
    fileprivate func setSubViews() {
        subviews.forEach { $0.removeFromSuperview() }
        addSubview(maskBgView)
        maskBgView.addSubview(containerView)
        containerView.addSubview(iconImgView)
        containerView.addSubview(progressView)
        containerView.addSubview(contentLabel)
    }
    
    /// 初始化配置，状态类型及背景框位置及偏移量，默认居中
    public func setConfig(_ type: JJCHUDType, content: String, alignment: JJCHUDAlignment = .center, offset: CGPoint = .zero) {
        self.type = type
        self.content = content
        updateLayout(type, content: content, alignment: alignment, offset: offset)
        startTimer(self.type)
    }
    
    /// 更新约束、类型
    fileprivate func updateLayout(_ type: JJCHUDType, content: String, alignment: JJCHUDAlignment, offset: CGPoint) {
        // 蒙版位置
        maskBgView.frame = bounds
        
        // 计算背景框尺寸
        let maxSize: CGSize = type == .message ? CGSize(width: JJC_IPhone6sRatio(500), height: CGFloat.greatestFiniteMagnitude) : CGSize(width: JJC_IPhone6sRatio(400), height: CGFloat.greatestFiniteMagnitude)
        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let size: CGSize = content.boundingRect(with: maxSize, options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading], attributes: attrs, context: nil).size

        var width: CGFloat = size.width + JJC_IPhone6sRatio(10)
        var height: CGFloat = size.height + JJC_IPhone6sRatio(10)
        width = width > (type == .message ? JJC_IPhone6sRatio(500) : JJC_IPhone6sRatio(400)) ? (type == .message ? JJC_IPhone6sRatio(500) : JJC_IPhone6sRatio(400)) : width
        width = width < containerVW ? containerVH : width
        width = width + 16 * 2
        height = height > JJC_IPhone6sRatio(200) ? JJC_IPhone6sRatio(200) : height
        height = height < JJC_IPhone6sRatio(40) ? JJC_IPhone6sRatio(40) : height
        height = height + (type == .message ? (JJC_IPhone6sRatio(32) * 2) : (contentTop + JJC_IPhone6sRatio(32)))

        // 更新背景框位置
        updateLayout(alignment, offset, width: width, height: height)

        // 更新背景框内部控件隐藏
        iconImgView.frame = CGRect(x: (containerView.jjc_width - iconImgVWH) * 0.5,
                                   y: JJC_IPhone6sRatio(40),
                                   width: iconImgVWH,
                                   height: iconImgVWH)
        iconImgView.isHidden = (type != .success && type != .failure)
        iconImgView.image = type == .success ? JJC_Image("status_default_success") : (type == .failure ? JJC_Image("status_default_failure") : nil)
        
        // 进度框
        progressView.frame = CGRect(x: (containerView.jjc_width - iconImgVWH) * 0.5,
                                    y: JJC_IPhone6sRatio(40),
                                    width: iconImgVWH,
                                    height: iconImgVWH)
        progressView.isHidden = (type != .loading && type != .progress)
        
        // 更新文本内容约束
        let contentLabelY = type == .message ? JJC_IPhone6sRatio(32) : contentTop
        contentLabel.frame = CGRect(x: 16,
                                    y: contentLabelY,
                                    width: containerView.jjc_width - 16 * 2,
                                    height: containerView.jjc_height - contentLabelY - JJC_IPhone6sRatio(32))
        contentLabel.text = content
        
        if type == .loading {
            progressView.startLoading()
        }
    }
    
    /// 更新背景框位置
    fileprivate func updateLayout(_ alignment: JJCHUDAlignment, _ offset: CGPoint, width: CGFloat, height: CGFloat) {
        switch alignment {
        case .center:
            containerView.frame = CGRect(x: (maskBgView.jjc_width - width) * 0.5 + offset.x,
                                         y: (maskBgView.jjc_height - height) * 0.5 + offset.y,
                                         width: width,
                                         height: height)
        case .top:
            containerView.frame = CGRect(x: (maskBgView.jjc_width - width) * 0.5 + offset.x,
                                         y: offset.y,
                                         width: width,
                                         height: height)
        case .bottom:
            containerView.frame = CGRect(x: (maskBgView.jjc_width - width) * 0.5 + offset.x,
                                         y: maskBgView.jjc_height - height + offset.y,
                                         width: width,
                                         height: height)
        case .left:
            containerView.frame = CGRect(x: offset.x,
                                         y: (maskBgView.jjc_height - height) * 0.5 + offset.y,
                                         width: width,
                                         height: height)
        case .right:
            containerView.frame = CGRect(x: maskBgView.jjc_width - width + offset.x,
                                         y: (maskBgView.jjc_height - height) * 0.5 + offset.y,
                                         width: width,
                                         height: height)
        case .topLeft:
            containerView.frame = CGRect(x: offset.x,
                                         y: offset.y,
                                         width: width,
                                         height: height)
        case .topRight:
            containerView.frame = CGRect(x: maskBgView.jjc_width - width + offset.x,
                                         y: offset.y,
                                         width: width,
                                         height: height)
        case .bottomLeft:
            containerView.frame = CGRect(x: offset.x,
                                         y: maskBgView.jjc_height - height + offset.y,
                                         width: width,
                                         height: height)
        case .bottomRight:
            containerView.frame = CGRect(x: maskBgView.jjc_width - width + offset.x,
                                         y: maskBgView.jjc_height - height + offset.y,
                                         width: width,
                                         height: height)
        }
    }
}

extension JJCHUD {
    /// 更新 背景框位置
    public func update(alignment: JJCHUDAlignment = .center, offset: CGPoint = .zero) {
        containerView.superview?.layoutIfNeeded()
        updateLayout(alignment, offset, width: containerView.frame.size.width, height: containerView.frame.size.height)
    }
    
    /// 更新信息（包含信息重置）
    public func update(content: String? = nil,
                       icon: UIImage? = nil,
                       progress: Float? = nil,
                       maskBgViewColor: UIColor? = nil,
                       containerViewColor: UIColor? = nil) {
        if let tempContent = content {
            contentLabel.text = tempContent
        }
        if type == .success || type == .failure {
            if let tempIcon = icon {
                iconImgView.image = tempIcon
            } else {
                iconImgView.image = type == .success ? JJC_Image("base_hud_success") : JJC_Image("base_hud_failure")
            }
        }
        if type == .loading || type == .progress {
            if let tempProgress = progress {
                progressView.update(progress: tempProgress)
            } else {
                progressView.update(progress: type == .loading ? 0.25 : 0)
            }
        }
        maskBgView.backgroundColor = maskBgViewColor ?? .clear
        containerView.backgroundColor = containerViewColor ?? UIColor(white: 0, alpha: 0.7)
    }
    
    /// 更新进度圆环信息
    public func update(lineWidth: CGFloat? = nil, lineBackgroundColor: UIColor? = nil, lineForeColor: UIColor? = nil) {
        if type == .loading || type == .progress {
            progressView.update(lineWidth: lineWidth, lineBackgroundColor: lineBackgroundColor, lineForeColor: lineForeColor)
        }
    }
}


//MARK: --------------------------------
//MARK: - 圆环
class JJCHUDProgressView: UIView {
    /// 进度
    fileprivate var progress: Float = 0
    /// 线条宽度
    fileprivate var lineWidth: CGFloat = 3
    /// 底部圆环颜色
    fileprivate var lineBackgroundColor: UIColor = UIColor(white: 1, alpha: 0.1)
    /// 顶部圆环颜色
    fileprivate var lineForeColor: UIColor = .white

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JJCHUDProgressView {
    /// 核心方法 - 重绘
    override func draw(_ rect: CGRect) {
        let radius: CGFloat = (rect.size.width - lineWidth) * 0.5
        let center: CGPoint = CGPoint(x: rect.size.width * 0.5, y: rect.size.height * 0.5)

        // 绘制底部圆环
        let bgPath = UIBezierPath()
        bgPath.lineWidth = lineWidth
        lineBackgroundColor.set()
        bgPath.lineCapStyle = .round
        bgPath.lineJoinStyle = .round
        bgPath.addArc(withCenter: center, radius: radius, startAngle: -Double.pi/2, endAngle: -Double.pi/2 + Double.pi*2, clockwise: true)
        bgPath.stroke()

        // 绘制顶部进度圆环
        let progressPath = UIBezierPath()
        progressPath.lineWidth = lineWidth
        lineForeColor.set()
        progressPath.lineCapStyle = .round
        progressPath.lineJoinStyle = .round
        progressPath.addArc(withCenter: center, radius: radius, startAngle: -Double.pi/2, endAngle: -Double.pi/2 + Double.pi*2*Double(progress), clockwise: true)
        progressPath.stroke()
    }
}

extension JJCHUDProgressView {
    /// 更新信息
    func update(progress: Float? = nil,
                lineWidth: CGFloat? = nil,
                lineBackgroundColor: UIColor? = nil,
                lineForeColor: UIColor? = nil) {
        if let tempProgress = progress {
            self.progress = tempProgress
        }
        if let tempLineWidth = lineWidth {
            self.lineWidth = tempLineWidth
        }
        if let tempLineBackgroundColor = lineBackgroundColor {
            self.lineBackgroundColor = tempLineBackgroundColor
        }
        if let tempLineForeColor = lineForeColor {
            self.lineForeColor = tempLineForeColor
        }
        setNeedsDisplay()
    }
    
    /// 加载动画
    func startLoading() {
        update(progress: 0.25)
        DispatchQueue.main.async {
            // 开启旋转动画
            let animation = CABasicAnimation(keyPath: "transform.rotation")
            animation.fromValue = 0
            animation.toValue = Double.pi * 2
            animation.duration = 2
            animation.autoreverses = false
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            animation.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
            self.layer.add(animation, forKey: "hud.transform.rotation.z")
        }
    }

    /// 结束动画
    func stopLoading() {
        layer.removeAnimation(forKey: "hud.transform.rotation.z")
    }
}
