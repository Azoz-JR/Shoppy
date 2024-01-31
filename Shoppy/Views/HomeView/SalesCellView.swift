//
//  SalesCellView.swift
//  Shoppy
//
//  Created by Azoz Salah on 31/01/2024.
//

import UIKit

class SalesCellView: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var salesCollectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    var images: [URL?] = []
    
    
    static let identifier = "SalesCell"
    
    static func register() -> UINib {
        UINib(nibName: "SalesCellView", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCollectionView()
    }
    
    func configure(with items: [URL?]) {
        images = items
        pageControl.numberOfPages = items.count
        
        salesCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SalesCollectionCellView.identifier, for: indexPath) as? SalesCollectionCellView {
            cell.saleImageView.sd_setImage(with: images[indexPath.row]) { _, _, _, _ in
                cell.activityIndicator.stopAnimating()
            }
            
            return cell
        }
        
        fatalError("Unable to dequeue SalesCollectionCellView")
    }
    
    private func configureCollectionView() {
        salesCollectionView.delegate = self
        salesCollectionView.dataSource = self
        salesCollectionView.register(SalesCollectionCellView.register(), forCellWithReuseIdentifier: SalesCollectionCellView.identifier)
        
        pageControl.currentPage = 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = (scrollView.contentOffset.x / scrollView.frame.width).rounded()
        pageControl.currentPage = Int(pageIndex)
    }

    @IBAction func pageControllTapped(_ sender: UIPageControl) {
        let index = sender.currentPage
        salesCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
}
