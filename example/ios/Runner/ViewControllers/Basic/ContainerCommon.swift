import Foundation

//
//    ___                   _
//   / __\_ _ _ __ __ _  __| | __ _ _   _
//  / _\/ _` | '__/ _` |/ _` |/ _` | | | |
// / / | (_| | | | (_| | (_| | (_| | |_| |
// \/   \__,_|_|  \__,_|\__,_|\__,_|\__, |
//                                  |___/
//
// GENERATED CODE BY Container CLI - DO NOT MODIFY BY HAND


protocol ContainerCommonHandler {

    // ---> protocol

    func handle(_ name: String, _ arguments: Any?, _ completion: @escaping (_ result: Any?) -> Void) -> Void
}

extension ContainerCommonHandler {

    func handle(_ name: String, _ arguments: Any?, _ completion: @escaping (_ result: Any?) -> Void) -> Void {
        if (!defaultHandle(name,arguments,completion)) {
            debugPrint("Container->Warning \(name) not handle. argument: \(arguments ?? "")")
        }
    }

    func defaultHandle(_ name: String, _ arguments: Any?, _ completion: @escaping (_ result: Any?) -> Void) -> Bool {
//        let args = arguments as? Dictionary<String, Any>
        // ---> impl
        return false
    }

}

