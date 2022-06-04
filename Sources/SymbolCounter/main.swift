import ArgumentParser
import Foundation

struct SymbolCount: ParsableCommand {

  @Argument(help: "The folder path of source files. Folder is traversed recursively.")
  var path: String

  @Option(name: .shortAndLong ,help: "All symbols you want to count")
  var symbols: String = """
  '<>".!+-=_^/*\\#&@[]%;|?():,${}~`
  """

  @Option(name: .shortAndLong ,help: "The filename extension filter of the source files to count")
  var fileExtension: String = "swift"

  static let configuration = CommandConfiguration(
    abstract: "A Swift command-line tool to count symbols in source files",
    subcommands: []
  )

  init() { }

  func run() throws {
    do {
      let folderURL = URL(fileURLWithPath: path)

      var files = [URL]()
      if let enumerator = FileManager.default.enumerator(
        at: folderURL,
        includingPropertiesForKeys: [.isRegularFileKey],
        options: [.skipsHiddenFiles, .skipsPackageDescendants]
      ) {

        for case let fileURL as URL in enumerator {
          do {
            let fileAttributes = try fileURL.resourceValues(forKeys: [.isRegularFileKey])
            if fileAttributes.isRegularFile!, fileURL.pathExtension == fileExtension {
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
        // A single quote is added so google sheets doesn't process it as a formula.
        print("'", terminator: "")
        print(f.key, f.value)
      }
      print()

      print("Adjacent symbols count (top 50)")
      for f in adjacentFrequencies
            .filter({ $0.key.count == 2 })
            .sorted(by: { $0.value > $1.value })
            .prefix(50)
      {
        print("'", terminator: "")
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
