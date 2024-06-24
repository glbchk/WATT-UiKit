//
//  CarDetailsView.swift
//  WATT
//
//  Created by Glib Galchenko on 22/04/24.
//

import UIKit

class CarDetailsView: UIView {
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    let viewContainer: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let blueBackgroundView = BlueBackgroundView()
    
    let blueBackgroundHeight = UIScreen.main.bounds.height * 0.35
    
    let whiteBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    var mainStack: UIStackView? = nil
    var topSectionStack: UIStackView? = nil
    var generalInfoStack: UIStackView? = nil
    var rangeInfoStack: UIStackView? = nil
    var performanceInfoStack: UIStackView? = nil
//    var buttonsStack: UIStackView? = nil
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Icons.Navigation.chevronLeft, for: .normal)
        button.tintColor = .white
        button.imageView?.fillSuperview()
        button.widthAnchor.constraint(equalToConstant: 18).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return button
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.constrainHeight(2)
        
        return view
    }()
    
    let titleLabel = TextLabel(title: "Car details", font: .systemFont(ofSize: 18, weight: .bold), textColor: .white, numberOfLines: 0)
    
    let topSection = TitleDetailsSection(brandName: "BMW", model: "xDrive", version: "Something else * 2019")
//    CarDetailsRow(title: "Brand name")
//    let modelNameRow = CarDetailsRow(title: "Model name")
//    let versionNameRow = CarDetailsRow(title: "Version name")
    
    let generalLabel = TextFieldLabel(title: "GENERAL")
    
    var realRangeRow = CarDetailsRow(title: "Real range")
    var fullBatteryRow = CarDetailsRow(title: "Full battery")
    var usableBatteryRow = CarDetailsRow(title: "Usable battery")
    var plugTypeRow = CarDetailsRow(title: "Plug type")
    
    let rangeLabel = TextFieldLabel(title: "RANGE")
    
//    let rangeCity: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 13)
//        label.textColor = Asset.Colors.grey1
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.5
//        return label
//    }()
//    
//    let rangeHighway: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 13)
//        label.textColor = Asset.Colors.grey1
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.5
//        return label
//    }()
//    
//    let rangeCombined: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 13)
//        label.textColor = Asset.Colors.grey1
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.5
//        return label
//    }()
    
    var titlesOfRangeColumns = RangeDetailsRow(situation: "Situation", bestRange: "Mild 23 ºC", worstRange: "Cold -10 ºC")
    var cityRange = RangeDetailsRow(situation: "City", bestRange: "200 km", worstRange: "100 km")
    var highwayRange = RangeDetailsRow(situation: "Highway", bestRange: "200 km", worstRange: "100 km")
    var combinedRange = RangeDetailsRow(situation: "Combined", bestRange: "200 km", worstRange: "100 km")
    
    let performanceLabel = TextFieldLabel(title: "PERFORMANCE")
    
    var accelerationRow = CarDetailsRow(title: "Acceleration")
    var topSpeedRow = CarDetailsRow(title: "Top speed")
    
    let additionalInfoLabel = TextFieldLabel(title: "ADDITIONAL INFO")
    
    var seatsNumberRow = CarDetailsRow(title: "Seats")
    var weightRow = CarDetailsRow(title: "Weight")
    var widthRow = CarDetailsRow(title: "Width")
    var heightRow = CarDetailsRow(title: "Height")
    
    let deleteCarButton = MainButton(title: "Delete car", titleColor: Asset.Colors.red, backgroundColor: .white, shadowOpacity: 0.15, shRadius: 5, shColor: .black)
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        
        addSubview(scrollView)
        scrollView.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        
        scrollView.addSubview(viewContainer)
        viewContainer.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, bottom: scrollView.bottomAnchor)
        viewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        setupBlueHeader()
        setupBackButton()
        setupTitleLabel()
        setupMainStack()
        
        setupDisconnectCarButton()
    }
    
    private func setupBlueHeader() {
        viewContainer.addSubview(blueBackgroundView)
        blueBackgroundView.anchor(top: viewContainer.topAnchor, leading: viewContainer.leadingAnchor, trailing: viewContainer.trailingAnchor, bottom: nil, size: .init(width: 0, height: blueBackgroundHeight))
        blueBackgroundView.setupGradient(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: blueBackgroundHeight))
    }
    
    private func setupBackButton() {
        blueBackgroundView.addSubview(backButton)
        backButton.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: self.safeAreaLayoutGuide.leadingAnchor, trailing: nil, bottom: nil, padding: .init(top: 20, left: 26, bottom: 0, right: 0))
    }
    
    private func setupTitleLabel() {
        blueBackgroundView.addSubview(titleLabel)
        titleLabel.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: nil, trailing: nil, bottom: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        titleLabel.centerXToSuperview()
    }
    
    private func setupWhiteFooter() {
        blueBackgroundView.addSubview(whiteBackgroundView)
        whiteBackgroundView.anchor(top: blueBackgroundView.topAnchor, leading: viewContainer.leadingAnchor, trailing: viewContainer.trailingAnchor, bottom: scrollView.bottomAnchor, padding: .init(top: 100, left: 0, bottom: 0, right: 0))
    }
    
    private func setupTopSection() {
        topSectionStack = stack(topSection)
        guard let topSectionStack = topSectionStack else { return }
        
        topSectionStack.anchor(top: blueBackgroundView.bottomAnchor, leading: viewContainer.leadingAnchor, trailing: viewContainer.trailingAnchor, bottom: nil, padding: .allSides(20))
        
        topSection.anchor(top: nil, leading: topSectionStack.leadingAnchor, trailing: topSectionStack.trailingAnchor, bottom: nil)
    }
    
    private func setupGeneralInfoStack() {
        let rowsStack = stack(realRangeRow, fullBatteryRow, usableBatteryRow, plugTypeRow, spacing: 2)
        generalInfoStack = stack(generalLabel, rowsStack, spacing: 16)
        
        guard let generalInfoStack = generalInfoStack else { return }
        generalInfoStack.anchor(top: topSectionStack?.bottomAnchor, leading: viewContainer.leadingAnchor, trailing: viewContainer.trailingAnchor, bottom: nil, padding: .allSides(20))
        
        [realRangeRow, fullBatteryRow, usableBatteryRow, plugTypeRow].forEach {
            $0.anchor(top: nil, leading: generalInfoStack.leadingAnchor, trailing: generalInfoStack.trailingAnchor, bottom: nil)
        }
    }
    
    private func setupRangeInfoStack() {
        
        let columns = stack(titlesOfRangeColumns, cityRange, highwayRange, combinedRange, spacing: 2)
        rangeInfoStack = stack(rangeLabel, columns, spacing: 16)
        
        guard let rangeInfoStack = rangeInfoStack else { return }
        rangeInfoStack.anchor(top: generalInfoStack?.bottomAnchor, leading: viewContainer.leadingAnchor, trailing: viewContainer.trailingAnchor, bottom: nil, padding: .allSides(20))
        
        [titlesOfRangeColumns, cityRange, highwayRange, combinedRange].forEach {
            $0.anchor(top: nil, leading: rangeInfoStack.leadingAnchor, trailing: rangeInfoStack.trailingAnchor, bottom: nil)
        }
    }
    
    private func setupPerformanceInfoStack() {
        let rowsStack = stack(accelerationRow, topSpeedRow, spacing: 2)
        performanceInfoStack = stack(performanceLabel, rowsStack, spacing: 16)
        
        guard let performanceInfoStack = performanceInfoStack else { return }
        performanceInfoStack.anchor(top: rangeInfoStack?.bottomAnchor, leading: viewContainer.leadingAnchor, trailing: viewContainer.trailingAnchor, bottom: nil, padding: .allSides(20))
        
        [accelerationRow, topSpeedRow].forEach {
            $0.anchor(top: nil, leading: performanceInfoStack.leadingAnchor, trailing: performanceInfoStack.trailingAnchor, bottom: nil)
        }
    }
    
    
    private func setupMainStack() {
        setupTopSection()
        setupGeneralInfoStack()
        setupRangeInfoStack()
        setupPerformanceInfoStack()
        
        if let topSectionStack = topSectionStack, let generalInfoStack = generalInfoStack, let rangeInfoStack = rangeInfoStack, let performanceInfoStack = performanceInfoStack {
            mainStack = stack(topSectionStack, generalInfoStack, rangeInfoStack, performanceInfoStack, spacing: 28)
        }
        
        guard let mainStack = mainStack else { return }
        viewContainer.addSubview(mainStack)
        
        mainStack.anchor(top: blueBackgroundView.bottomAnchor, leading: viewContainer.leadingAnchor, trailing: viewContainer.trailingAnchor, bottom: viewContainer.bottomAnchor, padding: .init(top: 20, left: 20, bottom: 160, right: 20))
        
        [topSectionStack, generalInfoStack, rangeInfoStack, performanceInfoStack].forEach {
            $0?.anchor(top: nil, leading: mainStack.leadingAnchor, trailing: mainStack.trailingAnchor, bottom: nil)
        }
        
    }
    
    private func setupDisconnectCarButton() {
        self.addSubview(deleteCarButton)
        deleteCarButton.anchor(top: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor, padding: .init(top: 0, left: 20, bottom: 50, right: 20))
    }
    
}

class TitleDetailsSection: UIView {
    
    let logoView: UIImageView = {
        let view = UIImageView()
        view.constrainHeight(60)
        view.constrainWidth(60)
        
        return view
    }()
    
    let logoContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        
        view.layer.borderColor = Asset.Colors.grey3.cgColor
        view.layer.borderWidth = 4.0
        view.constrainHeight(80)
        view.constrainWidth(80)
        
        return view
    }()
    
    let sectionView: UIView = {
       let bg = UIView()
        bg.backgroundColor = .clear
        bg.constrainHeight(100)
        bg.addBorder(to: .bottom, in: Asset.Colors.grey3, width: 1.0)
        
        return bg
    }()
    
    let brandNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 31)
        label.textColor = Asset.Colors.black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let slashLabel: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.font = .systemFont(ofSize: 13)
        label.textColor = Asset.Colors.grey1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let modelLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = Asset.Colors.grey1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = Asset.Colors.grey1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let idTitle: UILabel = {
        let label = UILabel()
        label.text = "ID:"
        label.font = .systemFont(ofSize: 13)
        label.textColor = Asset.Colors.grey1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = Asset.Colors.grey1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    init(brandName: String, model: String, version: String) {
        super.init(frame: .zero)
        self.brandNameLabel.text = brandName
        self.modelLabel.text = model
        self.versionLabel.text = version
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        self.addSubview(sectionView)
        
        logoView.image = Asset.Icons.location
        logoView.image?.withRenderingMode(.alwaysTemplate)
        
        logoContainer.addSubview(logoView)
        logoView.centerInSuperview()
        
        let modelAndVersionStack = hstack(modelLabel, slashLabel, versionLabel, spacing: 6)
        let idStack = hstack(idTitle, idLabel, spacing: 6)
        let labelsStack = stack(brandNameLabel, modelAndVersionStack, idStack, spacing: 4)
        
        let stack = hstack(logoContainer, labelsStack, spacing: 16, alignment: .center)
        
        sectionView.addSubview(stack)
        sectionView.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor)
        
        stack.anchor(top: sectionView.topAnchor, leading: sectionView.leadingAnchor, trailing: sectionView.trailingAnchor, bottom: sectionView.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        modelLabel.anchor(top: nil, leading: modelAndVersionStack.leadingAnchor, trailing: nil, bottom: nil)
    }
    
}

class CarDetailsRow: UIView {
    
    let mainLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = Asset.Colors.black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = Asset.Colors.grey1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }()
    
    let rightArrow: UIImageView = {
        let view = UIImageView(image: Asset.Icons.Navigation.chevronRight)
        view.contentMode = .scaleAspectFit
        view.tintColor = Asset.Colors.grey1
        view.constrainWidth(24)
        return view
    }()
    
    init(title: String, details: String? = nil) {
        super.init(frame: .zero)
        self.mainLabel.text = title
        self.detailsLabel.text = details
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        self.constrainHeight(50)
        self.addBorder(to: .bottom, in: Asset.Colors.grey3, width: 1.0)
        
        let stack = hstack(mainLabel, detailsLabel)
        
        self.addSubview(stack)
        
        stack.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor)
        
        mainLabel.anchor(top: nil, leading: stack.leadingAnchor, trailing: nil, bottom: nil)
        detailsLabel.anchor(top: nil, leading: nil, trailing: stack.trailingAnchor, bottom: nil)
    }
    
}

class RangeDetailsRow: UIView {
    
    let rowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.constrainHeight(50)
        view.addBorder(to: .bottom, in: Asset.Colors.grey3, width: 1.0)
        return view
    }()
    
    let firstLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = Asset.Colors.black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }()
    
    let secondLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = Asset.Colors.grey1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }()
    
    let thirdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = Asset.Colors.grey1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        return label
    }()
    
    init(situation: String = "City", bestRange: String = "720 km", worstRange: String = "520 km") {
        super.init(frame: .zero)
        self.firstLabel.text = situation
        self.secondLabel.text = bestRange
        self.thirdLabel.text = worstRange
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.addSubview(rowView)
        
        let stack = hstack(firstLabel, secondLabel, thirdLabel)
        
        rowView.addSubview(stack)
        firstLabel.constrainWidth(UIScreen.main.bounds.width / 3)
        
        thirdLabel.textAlignment = .left
        
        rowView.anchor(top: self.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, bottom: self.bottomAnchor)
        
        stack.anchor(top: rowView.topAnchor, leading: rowView.leadingAnchor, trailing: rowView.trailingAnchor, bottom: rowView.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
    }
    
}


extension UIView {
    enum ViewSide {
            case top
            case left
            case bottom
            case right
        }

        func addBorders(to sides: [ViewSide], in color: UIColor, width: CGFloat) {
            sides.forEach { addBorder(to: $0, in: color, width: width) }
        }

        func addBorder(to side: ViewSide, in color: UIColor, width: CGFloat) {
            switch side {
            case .top:
                addTopBorder(in: color, width: width)
            case .left:
                addLeftBorder(in: color, width: width)
            case .bottom:
                addBottomBorder(in: color, width: width)
            case .right:
                addRightBorder(in: color, width: width)
            }
        }

        func addTopBorder(in color: UIColor?, width borderWidth: CGFloat) {
            let border = UIView()
            border.backgroundColor = color
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            addSubview(border)
        }

        func addBottomBorder(in color: UIColor?, width borderWidth: CGFloat) {
            let border = UIView()
            border.backgroundColor = color
            border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            addSubview(border)
        }

        func addLeftBorder(in color: UIColor?, width borderWidth: CGFloat) {
            let border = UIView()
            border.backgroundColor = color
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            addSubview(border)
        }

        func addRightBorder(in color: UIColor?, width borderWidth: CGFloat) {
            let border = UIView()
            border.backgroundColor = color
            border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            addSubview(border)
        }
}
