//
//  PaginationContextTests.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-11-18.
//  Copyright © 2025-2026 Daniel Saidi. All rights reserved.
//

import Testing
import VideoKit

private struct TestItem: Paginable {
    let id: Int
}

@MainActor
@Suite("Pagination Context Tests")
struct PaginationContextTests {

    // MARK: - Init

    @Test
    func defaultInit_hasExpectedDefaults() {
        let context = PaginationContext<TestItem>()

        #expect(context.items.isEmpty)
        #expect(context.page == 1)
        #expect(context.canFetchNextPage == true)
        #expect(context.isLoading == false)
    }

    @Test
    func init_deduplicatesInitialItems_preservingOrder() {
        let items: [TestItem] = [
            .init(id: 1),
            .init(id: 1),
            .init(id: 2),
            .init(id: 2),
            .init(id: 3)
        ]

        let context = PaginationContext(items: items)

        #expect(context.items.map(\.id) == [1, 2, 3])
    }

    @Test
    func staticFactory_createsContextWithGivenItems_distinct() {
        let items: [TestItem] = [
            .init(id: 1),
            .init(id: 2),
            .init(id: 2)
        ]

        let context = PaginationContext<TestItem>.static(items: items)

        #expect(context.items.map(\.id) == [1, 2])
        #expect(context.page == 1)
        #expect(context.canFetchNextPage == true)
        #expect(context.isLoading == false)
    }

    // MARK: - appendNewPage

    @Test
    func appendNewPage_incrementsPage_andAppendsDistinctItems() {
        let initialItems: [TestItem] = [
            .init(id: 1),
            .init(id: 2)
        ]
        let newPageItems: [TestItem] = [
            .init(id: 2),   // duplicate
            .init(id: 3),
            .init(id: 4)
        ]

        let context = PaginationContext(items: initialItems)

        #expect(context.page == 1)
        #expect(context.items.map(\.id) == [1, 2])

        context.appendNewPage(newPageItems)

        #expect(context.page == 2)
        #expect(context.items.map(\.id) == [1, 2, 3, 4])
        #expect(context.canFetchNextPage == true)
    }

    @Test
    func appendNewPage_withEmptyPageItems_disablesFurtherFetching() {
        let context = PaginationContext(
            items: [
                TestItem(id: 1),
                TestItem(id: 2)
            ]
        )

        #expect(context.page == 1)
        #expect(context.canFetchNextPage == true)

        context.appendNewPage([])

        #expect(context.page == 2)
        #expect(context.items.map(\.id) == [1, 2])
        #expect(context.canFetchNextPage == false)
    }

    // MARK: - reset

    @Test
    func reset_resetsAllStateToDefaults() {
        let context = PaginationContext(
            items: [TestItem(id: 1)]
        )
        context.isLoading = true
        context.appendNewPage([.init(id: 2)])
        #expect(context.page == 2)
        #expect(context.items.isEmpty == false)
        #expect(context.canFetchNextPage == true)
        #expect(context.isLoading == true)

        context.reset()

        #expect(context.page == 1)
        #expect(context.items.isEmpty)
        #expect(context.canFetchNextPage == true)
        #expect(context.isLoading == false)
    }

    // MARK: - shouldLoadNextPage

    @Test
    func shouldLoadNextPage_returnsTrueForLastItem() {
        let items: [TestItem] = [
            .init(id: 1),
            .init(id: 2),
            .init(id: 3)
        ]
        let context = PaginationContext(items: items)

        let lastItem = TestItem(id: 3)
        #expect(context.shouldFetchNextPage(for: lastItem) == true)
    }

    @Test
    func shouldLoadNextPage_returnsFalseForNonLastItem() {
        let items: [TestItem] = [
            .init(id: 1),
            .init(id: 2),
            .init(id: 3)
        ]
        let context = PaginationContext(items: items)

        let middleItem = TestItem(id: 2)
        #expect(context.shouldFetchNextPage(for: middleItem) == false)
    }

    @Test
    func shouldLoadNextPage_returnsFalseWhenItemNotInList() {
        let items: [TestItem] = [
            .init(id: 1),
            .init(id: 2)
        ]
        let context = PaginationContext(items: items)

        let unknownItem = TestItem(id: 999)
        #expect(context.shouldFetchNextPage(for: unknownItem) == false)
    }

    @Test
    func shouldLoadNextPage_returnsFalseWhenListIsEmpty() {
        let context = PaginationContext<TestItem>()

        let item = TestItem(id: 1)
        #expect(context.shouldFetchNextPage(for: item) == false)
    }
}
