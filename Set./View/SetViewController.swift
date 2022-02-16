//
//  ViewController.swift
//  Set.
//
//  Created by Ilia Tsikelashvili on 16.02.22.
//

import UIKit

class SetViewController: UIViewController {

    private var constraints: [NSLayoutConstraint] = []
    private var collectionView : UICollectionView?
    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

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
    
    private var incrementalScoreTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .green
        label.isHidden = true
        label.text = "+1"
        return label
    }()
    
    private var decrementalScoreTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .red
        label.isHidden = true
        label.text = "-1"
        return label
    }()
    
    private var addThreeCardTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .black
        label.text = "Add Cards"
        return label
    }()
    
    private var newGameTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .black
        label.text = "New Game"
        return label
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
    
    private func configureStackViews() {
        [self.addThreeCardTitle,
         self.newGameTitle].forEach { buttonStackView.addArrangedSubview($0)}
        
        [self.incrementalScoreTitle,
         self.scoreTitle,
         self.decrementalScoreTitle].forEach { labelStackView.addArrangedSubview($0) }
    }
    
    private func configureCollectionView() {
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CollectionViewCell.self) )
        collectionView.backgroundColor = UIColor.black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
    }
    
    private func configureCollectionViewLayout() {
        guard let collectionView = collectionView else { return }
        
        layout.itemSize = CGSize(
            width: collectionView.frame.size.width / 4.5,
            height: collectionView.frame.size.height / 5.5)
        
        let contentHeight: CGFloat = collectionView.frame.size.height
        let cellHeight: CGFloat = layout.itemSize.height * 5
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
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCell.self), for: indexPath) as? CollectionViewCell else { return UICollectionViewCell.init() }
        cell.button.backgroundColor = .white
        return cell
    }
}
