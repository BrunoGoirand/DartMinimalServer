import 'dart:io';
import 'dart:isolate';

void main() async {
  //
  String returnedString = '';
  //
  final server = await ServerSocket.bind('localhost', 8765, shared: true);
  print('Server listening on ${server.address}:${server.port}');

  // Handle commands from the shell
  stdin.listen((data) async {
    final command = String.fromCharCodes(data).trim();
    if (command == 'exit') {
      // isolate.kill();
      server.close();
      exit(0);
    } else {
      print('Command received from shell: $command');
      returnedString = await handleCommands(command);
      print('Result computed: $returnedString');
    }
  });

  // Handle commands from the server
  await server.forEach((socket) {
    print('Client connected from ${socket.remoteAddress}:${socket.remotePort}');
    socket.listen((data) async {
      final command = String.fromCharCodes(data).trim();
      if (command == 'exit') {
        socket.close();
      } else {
        print('Command received from client: $command');
        returnedString = await handleCommands(command);
        socket.writeln('Command returned: $returnedString');
      }
    });
  });
}

//
Future<String> handleCommands(String command) async {
  //
  String returnedString = '';

  //
  switch (command) {
    case 'quit':
      // keepAlive = false;
      break;
    case 'date':
      final returnedData = await Isolate.run(() => _computeDate());
      returnedString = 'Received date: [$returnedData]';
      break;
    case 'time':
      final returnedData = await Isolate.run(() => _computeTime());
      returnedString = 'Received time: [$returnedData]';
      break;
    default:
      returnedString = 'invalid command [$command]';
      break;
  }

  return (returnedString);
}

//
Future<String> _computeDate() async {
  DateTime currentDate = DateTime.now();
  final returnedDate =
      'current date: ${currentDate.year}-${currentDate.month}-${currentDate.day}';
  return returnedDate;
}

Future<String> _computeTime() async {
  DateTime currentTime = DateTime.now();
  final returnedTime =
      'Current time: ${currentTime.hour}:${currentTime.minute}:${currentTime.second}';
  return returnedTime;
}
