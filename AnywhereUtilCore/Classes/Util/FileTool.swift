//
//  FileTool.swift
//  DropInUISDK
//
//  Created by chenghao guo on 2022/8/18.
//  Copyright © 2022 MAPHIVE TECHNOLOGY LIMITED. All rights reserved.
//

import Foundation

public class FileTool {
    // Return the root of this project
    /// - Returns: absolute path
    class func getProjectDataRoot() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths.first!
        return documentsDirectory
    }

    /// 根据相对路径拼合出绝对路径
    /// - Parameter relativePath: 保存的相对路径
    /// - Returns: 绝对路径
    public class func getFileAbsolutePath(withRelative path: String) -> String {
        let root = getProjectDataRoot()
        return root + "/" + path
    }

    public class func removeFile(_ file: URL) {
        let manager = FileManager.default
        if file.isFileExist() {
            try? manager.removeItem(at: file)
        }
    }

    public class func createDirectory(path: String) {
        if FileManager.default.fileExists(atPath: path) == false {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
            }
        }
    }

    class func createFile(atPath: String) -> Bool {
        if FileManager.default.fileExists(atPath: atPath) == false {
            return FileManager.default.createFile(atPath: atPath, contents: nil)
        }
        return false
    }

    // MARK: - Helpers
    public static func moveFile(fromUrl url: URL,
                         toDirectory directory: String?,
                         withName name: String) -> (Bool, Error?, URL?) {
        var newUrl: URL
        if let directory = directory {
            let directoryCreationResult = self.createDirectoryIfNotExists(withName: directory)
            guard directoryCreationResult.0 else {
                return (false, directoryCreationResult.1, nil)
            }
            newUrl = self.cacheDirectoryPath().appendingPathComponent(directory).appendingPathComponent(name)
        } else {
            newUrl = self.cacheDirectoryPath().appendingPathComponent(name)
        }
        do {
            try FileManager.default.moveItem(at: url, to: newUrl)
            return (true, nil, newUrl)
        } catch {
            return (false, error, nil)
        }
    }

    static func cacheDirectoryPath() -> URL {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: cachePath)
    }

    public static func doesFileExist(directory: FileManager.SearchPathDirectory, in directoryName: String?, fileName: String) -> String? {
        let fileManager = FileManager.default
        if let dirURL = fileManager.urls(for: directory, in: .userDomainMask).first {
            var folderURL = dirURL
            if let directoryName = directoryName {
                folderURL.appendPathComponent(directoryName)
            }
            let fileURL = folderURL.appendingPathComponent(fileName)
            if fileManager.fileExists(atPath: fileURL.path) {
                return fileURL.path
            }
        }
        return nil
    }

    public static func createDirectoryIfNotExists(withName name: String) -> (Bool, Error?) {
        let directoryUrl = self.cacheDirectoryPath().appendingPathComponent(name)
        if FileManager.default.fileExists(atPath: directoryUrl.path) {
            return (true, nil)
        }
        do {
            try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
            return (true, nil)
        } catch {
            return (false, error)
        }
    }

    public static func readFileContents(atPath fileURL: URL) -> Data? {
        do {
            let fileData = try Data(contentsOf: fileURL)
            return fileData
        } catch {
            print("无法读取文件: \(error.localizedDescription)")
            return nil
        }
    }
}
