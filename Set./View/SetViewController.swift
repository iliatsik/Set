//
//  ViewController.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 16.02.22.
//

import UIKit

class SetViewController: UIViewController, CollectionViewCellDelegate {
    
    private var constraints: [NSLayoutConstraint] = []
    private var collectionView : UICollectionView?
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private let viewModel = SetViewModel()
    private var button = [UIButton]()
    
    private var scoreTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.text = "0"
        return label
    }()
    private var addThreeCardTitle: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .boldSystemFont(ofSize: 25)
        button.setTitle("Add Cards", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(addThreeCard), for: .touchUpInside)
        return button
    }()
    
    private var newGameTitle: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .boldSystemFont(ofSize: 25)
        button.setTitle("New Game", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(newGame), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        viewModel.newGame()
        configureStackViews()
        configureCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configureAutoLayout()
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewLayout()
    }
}

extension SetViewController { //Private functions
    
    func updateView() {
        var cardIndex = 0
        for card in viewModel.set.currentCards {
            let button = self.button[cardIndex]
            CardTheme.setCard(card: card,
                              button: button,
                              isSelected: viewModel.cardIsSelected(card: card),
                              isSet: viewModel.isSet())
            cardIndex += 1
        }
    }
    
    func firstUpdateView(index: Int, button: UIButton) {
        CardTheme.setCard(card: viewModel.set.currentCards[index],
                          button: button,
                          isSelected: viewModel.cardIsSelected(card: viewModel.set.currentCards[index]),
                          isSet: viewModel.isSet())
    }
    
    @objc private func newGame() {
        viewModel.newGame()
        scoreTitle.text = "\(viewModel.score)"
        for index in 0..<button.count {
            button[index].setAttributedTitle(nil, for: .normal)
            if index < 4 || index > 15 { button[index].isHidden = true; button[index].isEnabled = false }
        }
        updateView()
    }
    
    @objc private func addThreeCard() {
        var addition = 0
        for index in 0..<button.count {
            if button[index].isHidden == true {
                button[index].isHidden = false
                button[index].isEnabled = true
                addition += 1
            }
            if addition == 3 { return }
        }
    }
    
    func onCardButton(sender: UIButton, index: Int) {
        scoreTitle.text = "\(viewModel.score)"
        viewModel.select(card: viewModel.set.currentCards[index])
        updateView()
    }
    
    private func configureStackViews() {
        [self.addThreeCardTitle,
         self.newGameTitle].forEach { buttonStackView.addArrangedSubview($0)}
        
        [self.scoreTitle].forEach { labelStackView.addArrangedSubview($0) }
    }
    
    private func configureCollectionView() {
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        
        collectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: String(describing: CollectionViewCell.self) )
        collectionView.backgroundColor = UIColor.black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
    }
    
    private func configureCollectionViewLayout() {
        guard let collectionView = collectionView else { return }
        
        layout.itemSize = CGSize(
            width: collectionView.frame.size.width / 4.5,
            height: collectionView.frame.size.height / 7)
        
        let contentHeight: CGFloat = collectionView.frame.size.height
        let cellHeight: CGFloat = layout.itemSize.height * 6
        let cellSpacing: CGFloat = 10 * 4
        collectionView.contentInset = UIEdgeInsets(top: (contentHeight - cellHeight - cellSpacing) / 2, left: 0, bottom: 0, right: 0)
    }
    
    private func configureAutoLayout() {
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        view.addSubview(buttonStackView)
        view.addSubview(labelStackView)
        
        constraints.append(contentsOf: [
            
            labelStackView.topAnchor.constraint(equalTo: view.topAnchor,
                                                constant: view.safeAreaInsets.top * 1.5),
            labelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            /* For Collection view, we are using center x, which is defined as the view's center X,
             center y as view's center y with constant: view's top safe area multiplied by two, height is defined as 65/100 of the view's height, width as the view's height with constant: view's top safe area */
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                    constant: -view.safeAreaInsets.top),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                  constant: -(view.safeAreaInsets.top)),
            
            /* For labelStackView, top anchor is connected with Collection View's bottom anchor,
             width is equal to the Collection View, center X is defined as view's center X */
            buttonStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor,
                                                 constant: view.safeAreaInsets.top),
            buttonStackView.widthAnchor.constraint(equalTo: collectionView.widthAnchor),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

extension SetViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath) as? CollectionViewCell
        else { return UICollectionViewCell.init() }
        
        cell.configure(delegate: self,
                       at: indexPath.row)
        self.button.append(cell.button)
        return cell
    }
}
