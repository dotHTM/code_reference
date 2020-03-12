

import Foundation

struct SudokuPuzzle<Element: Hashable> {
    typealias PEArray = [Element]
    typealias PESet = Set<Element>
    typealias Grid = [PEArray]

    let grid: Grid
    let legalValues: PEArray
    let emptyValue: Element

    var length: Int { grid.count } // length
    var width: Int {
        if grid.count > 0 { return grid.map { e in e.count }.max()! }
        return 0
    } // width
    var size: Int { boxSize * boxSize }
    var boxSize: Int { Int(sqrt(Double(legalValues.count))) }
    var safeSquare: Grid { underwriteBlank().grid }

    var empty: Self { Self(grid: [], legalValues: legalValues, emptyValue: emptyValue) }

    var blankGrid: Grid {
        var tempGrid: Grid = []
        for _ in 1 ... size {
            var tempRow: PEArray = []
            for _ in 1 ... size { tempRow.append(emptyValue) }
            tempGrid.append(tempRow)
        }
        return tempGrid
    }

    var blank: Self {
        !legalValues.contains(where: { e in e == emptyValue }) ? updateGrid(blankGrid) : empty
    } // blank

    static func rules(legalValues: PEArray, emptyValue: Element) -> Self? {
        if !legalValues.contains(emptyValue) {
            let candidatePuzzle = Self(grid: [], legalValues: legalValues, emptyValue: emptyValue)
            if candidatePuzzle.legalValues.count == candidatePuzzle.size { return candidatePuzzle }
        }
        return nil
    } // rules

    func updateGrid(_ newValue: Grid) -> Self {
        Self(grid: newValue, legalValues: legalValues, emptyValue: emptyValue)
    } // updateGrid

    func underwriteBlank() -> Self {
        let blankPuzzle = blank
        var newGrid = blankPuzzle.grid
        for x in 0 ..< min(blankPuzzle.grid.count, grid.count) {
            for y in 0 ..< min(blankPuzzle.grid[x].count, grid[x].count) {
                let cell = grid[x][y]
                newGrid[x][y] = cell
            }
        }
        return updateGrid(newGrid)
    } // underwriteBlank

    func validateCells() -> Self {
        updateGrid(
            underwriteBlank().grid
                .map { row in
                    row.map {
                        element in
                        legalValues.contains(element) ? element : emptyValue
                    }
                }
        )
    } // validateCells

    func rowContents(n: Int) -> PEArray? {
        safeSquare.at(n)
    }

    func colContents(n: Int) -> PEArray? {
        (0 ..< size).contains(n)
            ? safeSquare.map { row in row[n] }
            : nil
    }

    func boxContents(x: Int, y: Int) -> PEArray? {
        if (0 ..< size).contains(x), (0 ..< size).contains(y) {
            let xStart = Int(Double(x) / Double(boxSize)) * boxSize
            let yStart = Int(Double(y) / Double(boxSize)) * boxSize
            return safeSquare
                .enumerated()
                .filter { r in xStart <= r.offset && r.offset < xStart + boxSize }
                .map { $0.element }
                .map { r in
                    r.enumerated()
                        .filter { e in yStart <= e.offset && e.offset < yStart + boxSize }
                        .map { $0.element }
                }
                .reduce([]) { result, row in var clone = result!; clone.append(contentsOf: row); return clone }
        }

        return nil
    }

    func possible(x: Int, y: Int) -> PEArray? {
        if let box = boxContents(x: x, y: y),
            let row = rowContents(n: x),
            let col = colContents(n: y) {
            if legalValues.contains(grid[x][y]) { return [grid[x][y]] }
            var seen = PESet()
            for a in [box, row, col] { seen = seen.union(a) }
            var remaining = PESet(legalValues)
            for e in seen { remaining.remove(e) }
            return PEArray(remaining)
        }
        return nil
    } // possible

    func pidgeonHole() -> Self {
        var newGrid = blankGrid
        for x in 0 ..< size {
            for y in 0 ..< size {
                if let possible = possible(x: x, y: y) {
                    if possible.count == 1 { newGrid[x][y] = possible[0] }
                    else { newGrid[x][y] = emptyValue }
                }
            }
        }
        return updateGrid(newGrid)
    }

    func pidgeonHoleSolve() -> Self {
        var old = blankGrid
        var new = grid
        while new != old {
            old = new
            new = updateGrid(old).pidgeonHole().grid
        }
        return updateGrid(new)
    } // pidgeonHoleSolve

    func looseSolve() -> Self? {
     return nil
    } // looseSolve

    func solve() -> Self {
        pidgeonHoleSolve()
    } // solve
} // SudokuPuzzle

extension Array {
    func at(_ index: Int) -> Element? {
        (0 ..< count).contains(index) ? self[index] : nil
    }
} // Array

extension SudokuPuzzle: CustomStringConvertible {
    var description: String {
        var desc = "grid: ["
        if length > 0 { desc += "\n" }
        for row in grid { desc += "    \(row)\n" }
        desc +=
            """
            ]
            length  : \(length)
            width   : \(width)
            size    : \(size)
            boxSize : \(boxSize)
            """
        return desc
    }
} // SudokuPuzzle

let rules = (legalValues: [1, 2, 3, 4, 5, 6, 7, 8, 9], emptyValue: 0)
let proposedGrid = [
    [0, 0, 0, 0, 7, 0, 0, 3, 0],
    [0, 0, 5, 0, 0, 0, 1, 0, 0],
    [0, 8, 0, 3, 0, 9, 0, 0, 0],
    [5, 0, 3, 0, 2, 7, 0, 8, 0],
    [6, 0, 0, 0, 0, 0, 0, 0, 7],
    [0, 0, 2, 5, 0, 0, 0, 0, 0],
    [0, 0, 0, 4, 5, 0, 0, 0, 8],
    [0, 4, 0, 0, 0, 0, 0, 6, 0],
    [0, 0, 0, 0, 0, 6, 0, 0, 9],
]

if let myPuzzle = SudokuPuzzle
    .rules(legalValues: rules.legalValues, emptyValue: rules.emptyValue)?
    .updateGrid(
        proposedGrid
    ).validateCells()
     {
    print(myPuzzle.possible(x: 0, y: 0)!)
} else {
    print("Rules are inconsistant")
    print()
}
