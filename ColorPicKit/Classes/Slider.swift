//
//  Slider.swift
//  ColorPicKitExample
//
//  Created by Zakk Hoyt on 10/26/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//
import UIKit


@IBDesignable public class Slider: UIControl, SliderControl, Colorable {

    
    // MARK: Variables
    
    private var _value: CGFloat = 0.5
    @IBInspectable public var value: CGFloat {
        get {
            return _value
        }
        set {
            if _value != newValue {
                if newValue < 0 {
                    _value = 0
                } else if newValue > 1.0 {
                    _value = 1.0
                } else {
                    _value = newValue
                }
                updateKnob()
            }
        }
    }
    
    private var _knobView: KnobView = KnobView()
    public var knobView: KnobView {
        get {
            return _knobView
        }
        set {
            _knobView = newValue
            updateKnob()
        }
    }
    
    private var _knobSize: CGSize = CGSize(width: 30, height: 30)
    @IBInspectable public var knobSize: CGSize {
        get {
            return _knobSize
        }
        set {
            _knobSize = newValue
            updateKnob()
        }
    }
    
    private var _barHeight: CGFloat = 10
    @IBInspectable public var barHeight: CGFloat {
        get {
            return _barHeight
        }
        set {
            if _barHeight != newValue {
                _barHeight = newValue
                layoutSubviews()
            }
        }
    }
    
    

    
    private var _borderColor: UIColor = .lightGray
    @IBInspectable public var borderColor: UIColor{
        get {
            return _borderColor
        }
        set {
            _borderColor = newValue
            knobView.borderColor = newValue
            sliderView.borderColor = newValue
        }
    }
    
    private var _borderWidth: CGFloat = 0.5
    @IBInspectable public var borderWidth: CGFloat{
        get {
            return _borderWidth
        }
        set {
            _borderWidth = newValue
            knobView.borderWidth = newValue
            sliderView.borderWidth = newValue
        }
    }
    
    
    private var _roundedCornders: Bool = true
    @IBInspectable public var roundedCorners: Bool {
        get {
            return _roundedCornders
        }
        set {
            _roundedCornders = newValue
            sliderView.roundedCorners = newValue
        }
    }
    
    public override var intrinsicContentSize: CGSize  {
        get {
            return CGSize(width: bounds.width, height: 20)
        }
    }

    public var color: UIColor {
        get {
            return colorFrom(value: value)
        }
    }
    
    func colorFrom(value: CGFloat) -> UIColor {
        assert(false, "Child must implement")
    }
    
    var sliderView: SliderView!
    
    
    // MARK: Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.clear
        
        configureBackgroundView()
        
        // Knob view
        knobView.borderWidth = borderWidth
        knobView.borderColor = borderColor
        addSubview(knobView)
        
        // Pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHappened))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        self.addGestureRecognizer(panGesture)

        // Long press gesture
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHappened))
        self.addGestureRecognizer(longPressGesture)
    }
    
    func configureBackgroundView() {
        assert(false, "Child must implement")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        sliderView.frame = frameForSliderView()
        updateKnob()
    }
    
    
    fileprivate var knobStart: CGPoint!
    fileprivate var panStart: CGPoint!

    @objc private func panGestureHappened(sender: UIPanGestureRecognizer) {

        // Position
        if sender.state == .began {
            knobStart = knobView.center
            panStart = sender.location(in: self)
        }

        let deltaX = sender.location(in: self).x - panStart.x
        let newX = knobStart.x + deltaX
        
        let point = CGPoint(x: newX, y: knobStart.y)
        
        // Events
        if sender.state == .began {
            touchesHappened(point)
            touchDown()
        } else if sender.state == .changed {
            touchesHappened(point)
        } else if sender.state == .ended {
            touchesHappened(point)
            touchUpInside()
        }
        
    }
    
    @objc private func longPressGestureHappened(sender: UILongPressGestureRecognizer) {
        
        let x = sender.location(in: self).x
        let y = bounds.midY
        let point = CGPoint(x: x, y: y)

        
        if sender.state == .began {
            touchesHappened(point)
            touchDown()
        } else if sender.state == .changed {
            touchesHappened(point)
        } else if sender.state == .ended {
            touchesHappened(point)
            touchUpInside()
        }

    }
    
    

    private func touchesHappened(_ point: CGPoint) {
        updateValueWith(point: point)
        updateKnob()
        valueChanged()
    }
    
    func touchDown() {
        self.sendActions(for: .touchDown)
    }
    
    func touchUpInside() {
        self.sendActions(for: .touchUpInside)
    }
    
    func valueChanged() {
        self.sendActions(for: .valueChanged)
    }
    
    
    // MARK: Private methods
    
    private var inset: CGFloat {
        get {
            return knobSize.width / 2.0
        }
    }

    private func updateValueWith(point: CGPoint) {
        var x = point.x
        if x < inset {
            x = inset
        }
        if x > bounds.width - inset {
            x = bounds.width - inset
        }
        self.value = (x - inset) / (bounds.width - 2*inset)
    }
    
    private func updateKnob() {
        updateKnobPosition()
        updateKnobColor()
    }
    
    private func updateKnobPosition() {
        let x = inset + value * (bounds.width - 2*inset)
        knobView.bounds = CGRect(x: 0, y: 0, width: knobSize.width, height: knobSize.height)
        knobView.center = CGPoint(x: x, y:  bounds.midY)

    }
    
    func updateKnobColor() {
        //        knobView.borderColor = color
        knobView.color = color
    }
    
    private func frameForSliderView() -> CGRect {
        let x: CGFloat = 0
        let y: CGFloat = (bounds.height - barHeight) / 2.0
        let w: CGFloat = bounds.width
        let h: CGFloat = barHeight
        return CGRect(x: x, y: y, width: w, height: h)
    }
}
