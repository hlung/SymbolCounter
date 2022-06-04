import ArgumentParser
import Foundation

struct SymbolCount: ParsableCommand {

  static let configuration = CommandConfiguration(
    abstract: "A Swift command-line tool to count symbols in source files",
    subcommands: []
  )

  init() { }

  func run() throws {
    do {
      // Set the url of the folder you want to count here:
      let folderURL = URL(fileURLWithPath: "/Users/thongchai.kolyutsaku/Downloads/RxSwift-main")

      // Set symbols you want to count here:
      let symbols = """
      '<>".!+-=_^/*\\#&@[]%;|?():,${}~`
      """

      var files = [URL]()
      if let enumerator = FileManager.default.enumerator(
        at: folderURL,
        includingPropertiesForKeys: [.isRegularFileKey],
        options: [.skipsHiddenFiles, .skipsPackageDescendants]
      ) {

        for case let fileURL as URL in enumerator {
          do {
            let fileAttributes = try fileURL.resourceValues(forKeys: [.isRegularFileKey])
            if fileAttributes.isRegularFile!, fileURL.pathExtension == "swift" {
              files.append(fileURL)
            }
          } catch { print(error, fileURL) }
        }
//        print(files)
      }

      var frequencies = [Character: Int]()
      for c in symbols {
        frequencies[c] = 0
      }

      var adjacentFrequencies = [[Character]: Int]()
      var lineCount = 0

      for file in files {
        let content = try String(contentsOf: file)
        lineCount += content.split(separator: "\n").count

        var adjacentSymbols = [Character]()
        for c in content {
          if let f = frequencies[c] {
            frequencies[c] = f + 1
            adjacentSymbols.append(c)

            if adjacentSymbols.suffix(2).count == 2 {
              let key = Array(adjacentSymbols.suffix(2))
              adjacentFrequencies[key, default: 0] += 1
            }
          }
          else {
            adjacentSymbols.removeAll()
          }
        }
      }

      print("File count:", files.count)
      print("Line count:", lineCount)
      print()

      print("Symbols count")
      for f in frequencies.sorted(by: { $0.value > $1.value }) {
        print("'", terminator: "") // add single quote so when pasting in google sheets it doesn't process as a formula
        print(f.key, f.value)
      }
      print()

      print("Adjacent symbols count")
      for f in adjacentFrequencies
            .filter({ $0.key.count == 2 })
            .sorted(by: { $0.value > $1.value })
            .prefix(50)
      {
        print("'", terminator: "") // add single quote so when pasting in google sheets it doesn't process as a formula
        print(f.key.map { String($0) }.joined(), f.value)
      }

      print("Done")

    } catch {
      // failed to read directory – bad permissions, perhaps?
      print("Error", error)
    }
  }

}

SymbolCount.main()
