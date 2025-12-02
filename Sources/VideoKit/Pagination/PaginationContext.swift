//
//  PaginationContext.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-11-18.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import Foundation
import SwiftUI

/// This class can be used to manage a paginated data source.
public class PaginationContext<ItemType: Paginable>: ObservableObject {

    /// Create a context with an optional, initial item list.
    public init(
        items: [ItemType] = []
    ) {
        self.items = items.distinct()
    }

    /// Create a context with a static list of items.
    public static func `static`(
        items: [ItemType]
    ) -> PaginationContext<ItemType> {
        PaginationContext(items: items)
    }

    /// This is a typealias for a pagination fetch operation.
    public typealias FetchOperation = () -> Void

    @Published public private(set) var canFetchNextPage = true
    @Published public var isLoading = false
    @Published public var items: [ItemType]
    @Published public var page = 1
}

@MainActor
public extension PaginationContext {

    /// Append a new page of items.
    func appendNewPage(
        _ pageItems: [ItemType]
    ) {
        page += 1
        var newItems = items
        newItems.append(contentsOf: pageItems)
        newItems = newItems.distinct()
        items = newItems
        canFetchNextPage = pageItems.count > 0
    }

    /// Reset the pagination context.
    func reset() {
        page = 1
        items = []
        isLoading = false
        canFetchNextPage = true
    }

    /// Reset the pagination context and fetch new data.
    func startFetchingNewData(
        with fetchOperation: @escaping FetchOperation
    ) {
        reset()
        fetchOperation()
    }

    /// Check whether an item should trigger a pagination.
    func shouldFetchNextPage(
        for item: ItemType
    ) -> Bool {
        items.last?.id == item.id
    }

    /// Stop fetching data.
    func stopFetchingData() {
        isLoading = false
    }

    /// Try to fetch and append the next page for an item.
    ///
    /// This function will only trigger if the provided item
    /// is the last item in the current items collection. It
    /// should be called for every item on appear and should
    /// append any fetched items to the context.
    func tryFetchNextPage(
        for item: ItemType,
        fetchOperation: FetchOperation?
    ) {
        guard let fetchOperation else { return }
        guard shouldFetchNextPage(for: item) else { return }
        fetchOperation()
    }
}

private extension Collection where Element: Hashable {

    /// Get distinct, ordered values from the collection.
    func distinct() -> [Element] {
        reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
    }
}
