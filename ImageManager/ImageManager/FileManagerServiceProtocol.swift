//
//  FileManagerServiceProtocol.swift
//  ImageManager
//
//  Created by Aleksey Lexx on 19.02.2023.
//

import Foundation
import UIKit

protocol FileManagerServiceProtocol {
    
    func contentsOfDirectory(currentDirectory: URL) -> [URL]
    func createDirectory(folderPath: String)
    func createFile(currentDirectory: URL, fileName: String, image: UIImage)
    func removeContent(pathForItem: String)
    
}
