import qbs.Probes
import qbs.FileInfo
import "Protocol.js" as ProtocolHelpers

Library {
    name: "HarmonyProtocol"

    cpp.includePaths: product.buildDirectory
    property string protocolPath: "/usr/include/harmony-protocols"

    Probes.PkgConfigProbe {
        id: pkgConfig
        name: "harmony-protocol"
    }
    Group {
        files: protocolPath + "/*/*/*.proto"
        fileTags: "protocol"
    }
    Rule {
        inputs: ["protocol"]
        outputFileTags: ["cpp", "hpp", "pb-cc", "pb-h", "hrpc-types", "hrpc-client-cc", "hrpc-client-h"]

        outputArtifacts: ProtocolHelpers.getArtifacts(product, input)

        prepare: {
            var commands = ProtocolHelpers.prepare(product.protocolPath, product, input, outputs)
            return commands
        }
    }
    Group {
        fileTagsFilter: ["hpp", "pb-h", "hrpc-types", "hrpc-client-h"]
        qbs.install: true
        qbs.installDir: "include/chometz"
        qbs.installSourceBase: product.buildDirectory
    }
    Export {
        cpp.includePaths: product.buildDirectory
        prefixMapping: [{
            prefix: product.buildDirectory,
            replaement: FileInfo.joinPaths(qbs.installPrefix, "include/chometz")
        }]
        Depends { name: "cpp" }
        Depends { name: "croutons" }
        Depends { name: "vendored_protobuf" }
        Depends { name: "Qt"; submodules: ["core", "network", "concurrent", "websockets"] }
    }
    Depends { name: "cpp" }
    Depends { name: "croutons" }
    Depends { name: "vendored_protobuf" }
    Depends { name: "Qt"; submodules: ["core", "network", "concurrent", "websockets"] }
}