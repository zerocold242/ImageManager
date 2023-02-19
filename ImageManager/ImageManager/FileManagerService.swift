//
//  FileManagerService.swift
//  ImageManager
//
//  Created by Aleksey Lexx on 19.02.2023.
//

import Foundation
import UIKit

class FileManagerService: FileManagerServiceProtocol {
    
    static let shared = FileManagerService()
    private let fileManager = FileManager.default
    
    func contentsOfDirectory(currentDirectory: URL) -> [URL] {
        var contents: [URL] = []
        do {
            let files = try FileManager.default.contentsOfDirectory(at: currentDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            contents = files
        } catch {
            print(error.localizedDescription)
        }
        return contents
    }
    
    func createDirectory(folderPath: String) {
        do {
            try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: false)
        } catch {
            print(error)
        }
    }
    
    func createFile(currentDirectory: URL, fileName: String, image: UIImage) {
        let fileURL = currentDirectory.appendingPathComponent(fileName)
        
        do {
            FileManager.default.createFile(atPath: fileURL.path, contents: image.jpegData(compressionQuality: 1.0))
        }
    }
    
    func removeContent(pathForItem: String) {
        do {
            try FileManager.default.removeItem(atPath: pathForItem)
        } catch {
            print(error.localizedDescription)
        }
    }
}

