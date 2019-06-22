
import UIKit

public struct CollectionSupplementaryViewDescriptor {
    
    public let viewClass: UICollectionReusableView.Type
    public let configure: ((UICollectionReusableView) -> Void)?
    
    public init<View: UICollectionReusableView>(class: View.Type, configure: ((View) -> Void)? = nil) {
        
        self.viewClass = `class`
        
        if let configure = configure {
            self.configure = { view in (view as? View).map(configure) }
        } else {
            self.configure = nil
        }
    }
}

public struct CollectionCellDescriptor {
    
    public let cellClass: UICollectionViewCell.Type
    public let configure: ((UICollectionViewCell) -> Void)?
    
    public init<Cell: UICollectionViewCell>(cellClass: Cell.Type, configure: ((Cell) -> Void)? = nil) {
        
        self.cellClass = cellClass
        
        if let configure = configure {
            self.configure = { cell in (cell as? Cell).map(configure) }
        } else {
            self.configure = nil
        }
    }
}

public struct CollectionSection<Item> {

    public var items: [Item]
    public var supplementaryDescriptors: [String: CollectionSupplementaryViewDescriptor]

    public init(items: [Item] = [], supplementaryDescriptors: [String: CollectionSupplementaryViewDescriptor] = [:]) {
        self.items = items
        self.supplementaryDescriptors = supplementaryDescriptors
    }
}

open class CollectionDataSource<Item>: NSObject, UICollectionViewDataSource {

    public typealias Section = CollectionSection<Item>

    public var sections: [Section] = []
    
    public init(sections: [Section] = []) {
        self.sections = sections
        
        super.init()
    }
    
    public func item(at indexPath: IndexPath) -> Item? {
        
        guard
            case 0 ..< sections.count = indexPath.section,
            case 0 ..< sections[indexPath.section].items.count = indexPath.item
        else {
            return nil
        }
        
        return sections[indexPath.section].items[indexPath.item]
    }

    public func firstIndexPath(where predicate: (Item) -> Bool) -> IndexPath? {

        for (sectionIndex, section) in sections.enumerated() {
            for (itemIndex, item) in section.items.enumerated() {
                if predicate(item) {
                    return IndexPath(item: itemIndex, section: sectionIndex)
                }
            }
        }

        return nil
    }

    public var allIndexPaths: [IndexPath] {
        return sections.indices.flatMap(allIndexPaths(inSection:))
    }

    public func allIndexPaths(inSection sectionIndex: Int) -> [IndexPath] {
        return sections[sectionIndex].items.indices.map { IndexPath(item: $0, section: sectionIndex) }
    }

    open func cellDescriptor(for item: Item) -> CollectionCellDescriptor {
        fatalError("cellDescriptor(for:) must be overridden in subclass")
    }

    // MARK: UICollectionViewDataSource

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let item = self.item(at: indexPath) else {
            fatalError("""
                CollectionDataSource item for index path \(indexPath) not found.
                DataSource: \(self)
                Number of sections: \(sections.count)
                Collection view: \(collectionView)
                Collection view delegate: \(String(describing: collectionView.delegate))
            """)
        }
        
        let descriptor = cellDescriptor(for: item)
        let reuseIdentifier = String(describing: descriptor.cellClass)
        
        collectionView.register(descriptor.cellClass, forCellWithReuseIdentifier: reuseIdentifier)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        descriptor.configure?(cell)
        
        return cell
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        let section = sections[indexPath[0]]
        
        guard let descriptor = section.supplementaryDescriptors[kind] else {
            fatalError("No descriptor found for supplementary view of kind \(kind) at \(indexPath)")
        }
        
        let reuseIdentifier = kind + "_" + String(describing: descriptor.viewClass)
        
        collectionView.register(
            descriptor.viewClass,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: reuseIdentifier
        )
        
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        )
        
        descriptor.configure?(view)
        
        return view
    }
}

extension CollectionSection: Equatable where Item: Equatable {

    public static func == (lhs: CollectionSection, rhs: CollectionSection) -> Bool {
        return lhs.items == rhs.items && lhs.supplementaryDescriptors.keys == rhs.supplementaryDescriptors.keys
    }
}

extension CollectionDataSource where Item: Equatable {
    
    public func firstIndexPath(of item: Item) -> IndexPath? {
        
        guard
            let sectionIndex = sections.firstIndex(where: { $0.items.contains(item) }),
            let itemIndex = sections[sectionIndex].items.firstIndex(of: item)
        else {
            return nil
        }
        
        return IndexPath(item: itemIndex, section: sectionIndex)
    }
}

extension CollectionSection: CustomDebugStringConvertible {

    public var debugDescription: String {
        let itemsWithoutQualifiers = items.compactMap { String(describing: $0).split(separator: ".").last }
        return "Section(items: \(itemsWithoutQualifiers))"
    }
}
