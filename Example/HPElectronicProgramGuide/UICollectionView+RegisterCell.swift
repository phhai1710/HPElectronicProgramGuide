//
//  UICollectionView+RegisterCell.swift
//  HPElectronicProgramGuide_Example
//
//  Created by Hai Pham Huu on 25/02/2024.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {

    public func register<T: UICollectionViewCell>(cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.dequeueIdentifier)
    }

    public func register<T: UICollectionReusableView>(cellClass: T.Type,
                                                      forSupplementaryViewOfKind: String) {
        register(cellClass,
                 forSupplementaryViewOfKind: forSupplementaryViewOfKind,
                 withReuseIdentifier: cellClass.dequeueIdentifier)
    }

    public func dequeue<T: UICollectionViewCell>(cellClass: T.Type,
                                                 forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellClass.dequeueIdentifier,
                                             for: indexPath) as? T else {
            fatalError(
                "Error: cell with id: \(cellClass.dequeueIdentifier) for indexPath: \(indexPath) is not \(T.self)")
        }
        return cell
    }

}

extension UICollectionView {
    //WARNING: - To use these functions, the name of the Nib, Class and Cell's Id MUST-BE-SAME!!! with each other.
    
    func register<T: UICollectionViewCell>(cellNib: T.Type, bundle: Bundle? = nil) {
        let nib = UINib(nibName: cellNib.dequeueIdentifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: cellNib.dequeueIdentifier)
    }
}

extension UICollectionReusableView {
    public static var dequeueIdentifier: String {
        return String(describing: self)
    }
}
