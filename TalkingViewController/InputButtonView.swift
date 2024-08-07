import UIKit

protocol InputButtonViewDelegate: AnyObject {
    func keyboardWillShow(height: CGFloat)
    func keyboardWillHide()
}

class InputButtonView: UIView {

    weak var delegate: InputButtonViewDelegate?

    internal let leftButton1 = UIButton()
    internal let leftButton2 = UIButton()
    internal let leftButton3 = UIButton()
    internal let textField = UITextField()
    internal let rightButton = UIButton()
    internal let stackView = UIStackView()
    internal let collapseButton = UIButton()
    internal var isCollapsed = false

    private var keyboardHeight: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupView() {
        leftButton1.setImage(UIImage(systemName: "plus"), for: .normal)
        leftButton1.translatesAutoresizingMaskIntoConstraints = false

        leftButton2.setImage(UIImage(systemName: "camera"), for: .normal)
        leftButton2.translatesAutoresizingMaskIntoConstraints = false
        
        leftButton3.setImage(UIImage(systemName: "photo"), for: .normal)
        leftButton3.translatesAutoresizingMaskIntoConstraints = false

        textField.translatesAutoresizingMaskIntoConstraints = false

        rightButton.setImage(UIImage(systemName: "mic"), for: .normal)
        rightButton.translatesAutoresizingMaskIntoConstraints = false

//        stackView.alignment = .bottom
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(leftButton1)
        stackView.addArrangedSubview(leftButton2)
        stackView.addArrangedSubview(leftButton3)
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(rightButton)
        addSubview(stackView)

        stackView.backgroundColor = .darkGray
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            leftButton1.heightAnchor.constraint(equalTo: heightAnchor),
            leftButton1.widthAnchor.constraint(equalTo: leftButton1.heightAnchor),

            leftButton2.heightAnchor.constraint(equalTo: heightAnchor),
            leftButton2.widthAnchor.constraint(equalTo: leftButton2.heightAnchor),

            leftButton3.heightAnchor.constraint(equalTo: heightAnchor),
            leftButton3.widthAnchor.constraint(equalTo: leftButton3.heightAnchor),

            textField.topAnchor.constraint(equalTo: stackView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            textField.heightAnchor.constraint(equalTo: leftButton1.heightAnchor),

            rightButton.heightAnchor.constraint(equalTo: heightAnchor),
            rightButton.widthAnchor.constraint(equalTo: leftButton1.heightAnchor),
        ])

        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    //﻿ ﻿調整按鈕縮放
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        keyboardHeight = keyboardFrame.height
        delegate?.keyboardWillShow(height: keyboardHeight)

        // 改變按鈕1和按鈕2的透明度
        leftButton1.alpha = 0
        leftButton2.alpha = 0

        // 改變 leftButton3 的圖像
        leftButton3.setImage(UIImage(systemName: "chevron.right"), for: .normal)

        if !isCollapsed {
            collapseButtonTapped()
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        delegate?.keyboardWillHide()

        // 恢復按鈕1和按鈕2的透明度
        leftButton1.alpha = 1
        leftButton2.alpha = 1

        // 恢復 leftButton3 的圖像
        leftButton3.setImage(UIImage(systemName: "photo"), for: .normal)

        if isCollapsed {
            collapseButtonTapped()
        }
    }

    
    @objc private func collapseButtonTapped() {
        isCollapsed.toggle()
        UIView.animate(withDuration: 0.3) {
            if self.isCollapsed {
                self.stackView.removeArrangedSubview(self.leftButton1)
                self.stackView.removeArrangedSubview(self.leftButton2)
                self.stackView.removeArrangedSubview(self.leftButton3)
                self.stackView.insertArrangedSubview(self.collapseButton, at: 0)
            } else {
                self.stackView.removeArrangedSubview(self.collapseButton)
                self.stackView.insertArrangedSubview(self.leftButton1, at: 0)
                self.stackView.insertArrangedSubview(self.leftButton2, at: 1)
                self.stackView.insertArrangedSubview(self.leftButton3, at: 2)
            }
            self.stackView.layoutIfNeeded()
        }
    }
}

