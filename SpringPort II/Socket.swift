//
//  Socket.swift
//  OSXSpringLobby
//
//  Created by Belmakor on 30/06/2016.
//  Copyright © 2016 MasterBel2. All rights reserved.
//

import Foundation

protocol SocketDelegate: class {
    func socket(_ socket: Socket, didReceive message: String)
}

class Socket: NSObject {

    weak var delegate: SocketDelegate?

    let address: String
    let port: Int

    var inputStream: InputStream?
    var outputStream: OutputStream?

    var messageBuffer = NSMutableData(capacity: 256)!

    init(address: String, port: Int) {
        self.address = address
        self.port = port
    }

    var isConnected: Bool { return inputStream != nil && outputStream != nil }

    func connect() {
        guard !isConnected else {
            return
        }

        Stream.getStreamsToHost(withName: address, port: port, inputStream: &inputStream, outputStream: &outputStream)

        guard let
            input = inputStream,
            let output = outputStream
            else {
                print("Failed to get input & output streams")
                return
        }

        input.delegate = self
        output.delegate = self

        input.schedule(in: .current, forMode: RunLoopMode.defaultRunLoopMode)
        output.schedule(in: .current, forMode: RunLoopMode.defaultRunLoopMode)

        input.open()
        output.open()
    }

    func disconnect() {
        guard isConnected else {
            return
        }
        if let input = inputStream {
            input.close()
            input.remove(from: .current, forMode: RunLoopMode.defaultRunLoopMode)
            inputStream = nil
        }
        if let output = outputStream {
            output.close()
            output.remove(from: .current, forMode: RunLoopMode.defaultRunLoopMode)
            outputStream = nil
        }
    }

    func send(message: String) {
        guard let outputStream = outputStream else {
            print("Error: Not Connected")
            return
        } // not connected
        guard let data = message.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            print("Cannot convert message into data to send: invalid format?")
            return
        }
//         print("sending message: \(message)")
        var bytes = Array<UInt8>(repeating: 0, count: data.count)
        (data as NSData).getBytes(&bytes, length: data.count)
        outputStream.write(&bytes, maxLength: data.count)
    }

}

extension Socket: StreamDelegate {

    func stream(_ stream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {

        case Stream.Event():
            break

        case Stream.Event.openCompleted:
            break

        case Stream.Event.hasBytesAvailable:
            guard let input = stream as? InputStream else { break }

            var byte: UInt8 = 0
            while input.hasBytesAvailable {
                let bytesRead = input.read(&byte, maxLength: 1)
                messageBuffer.append(&byte, length: bytesRead)
            }
            // only inform our delegate of complete messages (must end in newline character)
            if let message = String(data: messageBuffer as Data, encoding: String.Encoding.utf8), message.hasSuffix("\n") {
                delegate?.socket(self, didReceive: message)
                messageBuffer.length = 0
            }

        case Stream.Event.hasSpaceAvailable:
            break

        case Stream.Event.errorOccurred:
            print("An error occurred: \(stream.streamError?.localizedDescription)")

        case Stream.Event.endEncountered:
            stream.close()
            stream.remove(from: .current, forMode: RunLoopMode.defaultRunLoopMode)
            if stream == inputStream {
                inputStream = nil
            } else if stream == outputStream {
                outputStream = nil
            }

        default:
            print(eventCode)
        }
    }

}
