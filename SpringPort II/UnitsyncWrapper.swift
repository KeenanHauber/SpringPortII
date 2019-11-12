//
//  UnitsyncWrapper.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 10/12/16.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

/**
 Provides convenience wrappers to the SpringRTS unitsync dynamic library.

 - Note: This class is *not thread safe*. Be sure to invoke all functions via `performBlock` for asynchronous processing, or `performBlockAndWait` for synchronous processing. This class uses a private serial queue to dispatch all operations.
 */
class UnitsyncWrapper: MapDataSource {

    private let handle: DynamicLibraryHandle
    private let queue = DispatchQueue(label: "com.springport.unitsyncwrapper")

    init?(config: UnitsyncConfig) {
        guard let handle = DynamicLibraryHandle(libraryPath: config.unitsyncPath) else {
            return nil
        }

        self.handle = handle

        // resolve the c functions we are going to use

        GetSpringVersion = handle.resolve("GetSpringVersion", type(of: GetSpringVersion))!
        IsSpringReleaseVersion = handle.resolve("IsSpringReleaseVersion", type(of: IsSpringReleaseVersion))!

        Init = handle.resolve("Init", type(of: Init))!
        UnInit = handle.resolve("UnInit", type(of: UnInit))!

        GetWritableDataDirectory = handle.resolve("GetWritableDataDirectory", type(of: GetWritableDataDirectory))!
        GetDataDirectoryCount = handle.resolve("GetDataDirectoryCount", type(of: GetDataDirectoryCount))!
        GetDataDirectory = handle.resolve("GetDataDirectory", type(of: GetDataDirectory))!

        ProcessUnits = handle.resolve("ProcessUnits", type(of: ProcessUnits))!
        GetUnitCount = handle.resolve("GetUnitCount", type(of: GetUnitCount))!
        GetUnitName = handle.resolve("GetUnitName", type(of: GetUnitName))!
        GetFullUnitName = handle.resolve("GetFullUnitName", type(of: GetFullUnitName))!

        AddArchive = handle.resolve("AddArchive", type(of: AddArchive))!
        AddAllArchives = handle.resolve("AddAllArchives", type(of: AddAllArchives))!
        RemoveAllArchives = handle.resolve("RemoveAllArchives", type(of: RemoveAllArchives))!
        GetArchiveChecksum = handle.resolve("GetArchiveChecksum", type(of: GetArchiveChecksum))!
        GetArchivePath = handle.resolve("GetArchivePath", type(of: GetArchivePath))!

        GetMapCount = handle.resolve("GetMapCount", type(of: GetMapCount))!
        //        GetMapInfoCount = handle.resolve("GetMapInfoCount", GetMapInfoCount.dynamicType)!
        GetMapName = handle.resolve("GetMapName", type(of: GetMapName))!
        GetMapFileName = handle.resolve("GetMapFileName", type(of: GetMapFileName))!
        GetMapDescription = handle.resolve("GetMapDescription", type(of: GetMapDescription))!
        GetMapAuthor = handle.resolve("GetMapAuthor", type(of: GetMapAuthor))!
        GetMapWidth = handle.resolve("GetMapWidth", type(of: GetMapWidth))!
        GetMapHeight = handle.resolve("GetMapHeight", type(of: GetMapHeight))!
        GetMapTidalStrength = handle.resolve("GetMapTidalStrength", type(of: GetMapTidalStrength))!
        GetMapWindMin = handle.resolve("GetMapWindMin", type(of: GetMapWindMin))!
        GetMapWindMax = handle.resolve("GetMapWindMax", type(of: GetMapWindMax))!
        GetMapGravity = handle.resolve("GetMapGravity", type(of: GetMapGravity))!
        GetMapResourceCount = handle.resolve("GetMapResourceCount", type(of: GetMapResourceCount))!
        GetMapResourceName = handle.resolve("GetMapResourceName", type(of: GetMapResourceName))!
        GetMapResourceMax = handle.resolve("GetMapResourceMax", type(of: GetMapResourceMax))!
        GetMapResourceExtractorRadius = handle.resolve("GetMapResourceExtractorRadius", type(of: GetMapResourceExtractorRadius))!
        GetMapPosCount = handle.resolve("GetMapPosCount", type(of: GetMapPosCount))!
        GetMapPosX = handle.resolve("GetMapPosX", type(of: GetMapPosX))!
        GetMapPosZ = handle.resolve("GetMapPosZ", type(of: GetMapPosZ))!
        GetMapMinHeight = handle.resolve("GetMapMinHeight", type(of: GetMapMinHeight))!
        GetMapMaxHeight = handle.resolve("GetMapMaxHeight", type(of: GetMapMaxHeight))!
        GetMapArchiveCount = handle.resolve("GetMapArchiveCount", type(of: GetMapArchiveCount))!
        GetMapArchiveName = handle.resolve("GetMapArchiveName", type(of: GetMapArchiveName))!
        GetMapChecksum = handle.resolve("GetMapChecksum", type(of: GetMapChecksum))!
        GetMapChecksumFromName = handle.resolve("GetMapChecksumFromName", type(of: GetMapChecksumFromName))!
        GetMinimap = handle.resolve("GetMinimap", type(of: GetMinimap))!
        GetInfoMapSize = handle.resolve("GetInfoMapSize", type(of: GetInfoMapSize))!
        GetInfoMap = handle.resolve("GetInfoMap", type(of: GetInfoMap))!

        GetSkirmishAICount = handle.resolve("GetSkirmishAICount", type(of: GetSkirmishAICount))!
        GetSkirmishAIInfoCount = handle.resolve("GetSkirmishAIInfoCount", type(of: GetSkirmishAIInfoCount))!
        GetInfoKey = handle.resolve("GetInfoKey", type(of: GetInfoKey))!
        GetInfoType = handle.resolve("GetInfoType", type(of: GetInfoType))!
        GetInfoValueString = handle.resolve("GetInfoValueString", type(of: GetInfoValueString))!
        GetInfoValueInteger = handle.resolve("GetInfoValueInteger", type(of: GetInfoValueInteger))!
        GetInfoValueFloat = handle.resolve("GetInfoValueFloat", type(of: GetInfoValueFloat))!
        GetInfoValueBool = handle.resolve("GetInfoValueBool", type(of: GetInfoValueBool))!
        GetInfoDescription = handle.resolve("GetInfoDescription", type(of: GetInfoDescription))!
        GetSkirmishAIOptionCount = handle.resolve("GetSkirmishAIOptionCount", type(of: GetSkirmishAIOptionCount))!

        GetPrimaryModCount = handle.resolve("GetPrimaryModCount", type(of: GetPrimaryModCount))!
        GetPrimaryModInfoCount = handle.resolve("GetPrimaryModInfoCount", type(of: GetPrimaryModInfoCount))!
        GetPrimaryModArchive = handle.resolve("GetPrimaryModArchive", type(of: GetPrimaryModArchive))!
        GetPrimaryModArchiveCount = handle.resolve("GetPrimaryModArchiveCount", type(of: GetPrimaryModArchiveCount))!
        GetPrimaryModArchiveList = handle.resolve("GetPrimaryModArchiveList", type(of: GetPrimaryModArchiveList))!
        GetPrimaryModIndex = handle.resolve("GetPrimaryModIndex", type(of: GetPrimaryModIndex))!
        GetPrimaryModChecksum = handle.resolve("GetPrimaryModChecksum", type(of: GetPrimaryModChecksum))!
        GetPrimaryModChecksumFromName = handle.resolve("GetPrimaryModChecksumFromName", type(of: GetPrimaryModChecksumFromName))!

        GetSideCount = handle.resolve("GetSideCount", type(of: GetSideCount))!
        GetSideName = handle.resolve("GetSideName", type(of: GetSideName))!
        GetSideStartUnit = handle.resolve("GetSideStartUnit", type(of: GetSideStartUnit))!

        _ = Init(false, 0)
    }

    deinit {
        UnInit()
    }

    func performBlock(_ block: @escaping ()->()) {
        queue.async(execute: block)
    }

    func performBlockAndWait(_ block: ()->()) {
        queue.sync(execute: block)
    }

    // MARK: - Public API

    var springVersion: String {
        return String(cString: GetSpringVersion())
    }

    var mapCount: Int { return Int(GetMapCount()) }
	
	func mapIdentification(at index: Int) -> (String, Int32, String, Int) {
		let cIndex = CInt(index)
		let mapName = String(cString: GetMapName(cIndex))
		let checksum = GetMapChecksum(cIndex)
		let fileName = String(cString: GetMapFileName(cIndex))
		return (mapName, checksum, fileName, index)
	}
    
    func mapData(for map: Map) -> MapData {
        let cIndex = CInt(map.index)
		let mapName = map.name.cString(using: .utf8)!

		let description = String(cString: GetMapDescription(cIndex))
        let mapWidth = Int(GetMapWidth(cIndex))
        let mapHeight = Int(GetMapHeight(cIndex))
        let tidalStrength = Int(GetMapTidalStrength(cIndex))
        let windMin = Int(GetMapWindMin(cIndex))
        let windMax = Int(GetMapWindMax(cIndex))
        let mapGravity = Int(GetMapGravity(cIndex))
        let resourceCount = Int(GetMapResourceCount(cIndex))
		
		let otherPointer = UnsafePointer(mapName)
		
		let mipLevel = 0
		let minimapPointer = GetMinimap(otherPointer, CInt(mipLevel))
		let miniMapData: [UInt16] = Array(UnsafeBufferPointer(start: minimapPointer, count: 1024 * 1024))
		
        let mapData = MapData(
            description: description,
            mapWidth: mapWidth,
            mapHeight: mapHeight,
            tidalStrength: tidalStrength,
            windMin: windMin,
            windMax: windMax,
            mapGravity: mapGravity,
            resourceCount: resourceCount,
            miniMapData: miniMapData)
        return mapData
    }
	
    var gameCount: Int { return Int(GetPrimaryModCount()) } // Mods in unitsync are actually games

    // MARK: - PRIVATE -- handles to all the unitsync functions

    // Spring version
    private let GetSpringVersion: @convention(c) () -> UnsafePointer<CChar>
    private let IsSpringReleaseVersion: @convention(c)() -> Bool

    // Initialization/Un-init
    private let Init: @convention(c) (Bool, CInt) -> CInt
    private let UnInit: @convention(c) () -> Void

    private let GetWritableDataDirectory: @convention(c) () -> UnsafePointer<CChar>
    private let GetDataDirectoryCount: @convention(c) () -> CInt
    private let GetDataDirectory: @convention(c) (CInt) -> UnsafePointer<CChar>

    private let ProcessUnits: @convention(c) () -> CInt
    private let GetUnitCount: @convention(c) () -> CInt
    private let GetUnitName: @convention(c) (CInt) -> UnsafePointer<CChar>
    private let GetFullUnitName: @convention(c) (CInt) -> UnsafePointer<CChar>

    private let AddArchive: @convention(c) (UnsafePointer<CChar>) -> Void
    private let AddAllArchives: @convention(c) (UnsafePointer<CChar>) -> Void
    private let RemoveAllArchives: @convention(c) () -> Void
    private let GetArchiveChecksum: @convention(c) (UnsafePointer<CChar>) -> Int32
    private let GetArchivePath: @convention(c) (UnsafePointer<CChar>) -> UnsafePointer<CChar>

    // Map related functions
    private let GetMapCount: @convention(c) () -> CInt
    //    private let GetMapInfoCount: @convention(c) (CInt) -> CInt
    private let GetMapName: @convention(c) (CInt) -> UnsafePointer<CChar>
    private let GetMapFileName: @convention(c) (CInt) -> UnsafePointer<CChar>
    private let GetMapDescription: @convention(c) (CInt) -> UnsafePointer<CChar>
    private let GetMapAuthor: @convention(c) (CInt) -> UnsafePointer<CChar>
    private let GetMapWidth: @convention(c) (CInt) -> CInt
    private let GetMapHeight: @convention(c) (CInt) -> CInt
    private let GetMapTidalStrength: @convention(c) (CInt) -> CInt
    private let GetMapWindMin: @convention(c) (CInt) -> CInt
    private let GetMapWindMax: @convention(c) (CInt) -> CInt
    private let GetMapGravity: @convention(c) (CInt) -> CInt
    private let GetMapResourceCount: @convention(c) (CInt) -> CInt
    private let GetMapResourceName: @convention(c) (CInt,CInt) -> UnsafePointer<CChar>
    private let GetMapResourceMax: @convention(c) (CInt,CInt) -> CFloat
    private let GetMapResourceExtractorRadius: @convention(c) (CInt,CInt) -> CInt
    private let GetMapPosCount: @convention(c) (CInt) -> CInt
    private let GetMapPosX: @convention(c) (CInt,CInt) -> CFloat
    private let GetMapPosZ: @convention(c) (CInt,CInt) -> CFloat
    private let GetMapMinHeight: @convention(c) (UnsafePointer<CChar>) -> CFloat
    private let GetMapMaxHeight: @convention(c) (UnsafePointer<CChar>) -> CFloat
    private let GetMapArchiveCount: @convention(c) (UnsafePointer<CChar>) -> CInt
    private let GetMapArchiveName: @convention(c) (CInt) -> UnsafePointer<CChar>
    private let GetMapChecksum: @convention(c) (CInt) -> Int32
    private let GetMapChecksumFromName: @convention(c) (UnsafePointer<CChar>) -> Int32
    private let GetMinimap: @convention(c) (UnsafePointer<CChar>,CInt) -> UnsafeMutablePointer<UInt16>?
    private let GetInfoMapSize: @convention(c) (UnsafePointer<CChar>,UnsafePointer<CChar>,UnsafePointer<CInt>,UnsafePointer<CInt>) -> CInt
    private let GetInfoMap: @convention(c) (UnsafePointer<CChar>,UnsafePointer<CChar>,UnsafePointer<UInt8>,CInt) -> CInt

    private let GetSkirmishAICount: @convention(c) () -> CInt
    private let GetSkirmishAIInfoCount: @convention(c) (CInt) -> CInt
    private let GetInfoKey: @convention(c) (CInt) -> UnsafePointer<CChar>
    private let GetInfoType: @convention(c) (CInt) -> UnsafePointer<CChar>
    private let GetInfoValueString: @convention(c) (CInt) -> UnsafePointer<CChar>
    private let GetInfoValueInteger: @convention(c) (CInt) -> CInt
    private let GetInfoValueFloat: @convention(c) (CInt) -> CFloat
    private let GetInfoValueBool: @convention(c) (CInt) -> CBool
    private let GetInfoDescription: @convention(c) (CInt) -> UnsafePointer<CChar>
    private let GetSkirmishAIOptionCount: @convention(c) (CInt) -> CInt

    private let GetPrimaryModCount: @convention(c) () -> CInt
    private let GetPrimaryModInfoCount: @convention(c) (CInt) -> CInt
    private let GetPrimaryModArchive: @convention(c) (CInt) -> UnsafePointer<CChar>
    private let GetPrimaryModArchiveCount: @convention(c) (CInt) -> CInt
    private let GetPrimaryModArchiveList: @convention(c) (CInt) -> UnsafePointer<CChar>
    private let GetPrimaryModIndex: @convention(c) (UnsafePointer<CChar>) -> CInt
    private let GetPrimaryModChecksum: @convention(c) (CInt) -> Int32
    private let GetPrimaryModChecksumFromName: @convention(c) (UnsafePointer<CChar>) -> Int32

    private let GetSideCount: @convention(c) () -> CInt
    private let GetSideName: @convention(c) (CInt) -> UnsafePointer<CChar>
    private let GetSideStartUnit: @convention(c) (CInt) -> UnsafePointer<CChar>
}
