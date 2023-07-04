// file: searles.dart
// license: see LICENSE.md
//
import 'dart:io';
import 'dart:isolate';

void main() async {
  //
  // Get the prompt from environment variable if it is present
  String? prompt = Platform.environment['searlesPrompt'];
  // Otherwise set the default value
  prompt ??= '>';
  //
  String returnedString = '';
  //
  final server = await ServerSocket.bind(
    'localhost',
    8765,
    /* shared: true, */
  );
  print('Server listening on ${server.address}:${server.port}');

  // Display the prompt initially
  stdout.write('$prompt ');

  // Handle commands from the shell
  // only if it is not running as a service
  if (stdin.hasTerminal) {
    // stdin is available
    stdin.listen((data) async {
      final command = String.fromCharCodes(data).trim().toLowerCase();
      if (command == 'exit') {
        // Close all client connections ?
        // server.forEach((socket) {
        //   socket.close();
        // });
        server.close();
        exit(0);
      } else {
        print('Command received from shell: $command');
        returnedString = await handleCommands(command);
        print('Result computed: $returnedString');
        // Display the prompt again
        stdout.write('$prompt ');
      }
    });
  }

  // Handle commands from the server
  await server.forEach((socket) {
    print(
        '\rClient connected from ${socket.remoteAddress}:${socket.remotePort}');
    // Display the prompt again
    stdout.write('$prompt ');
    socket.listen((data) async {
      final command = String.fromCharCodes(data).trim().toLowerCase();
      if (command == 'exit') {
        socket.close();
      } else {
        print('\rCommand received from client: $command');
        returnedString = await handleCommands(command);
        socket.writeln('Command returned: $returnedString');
        // Display the prompt again
        stdout.write('$prompt ');
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
