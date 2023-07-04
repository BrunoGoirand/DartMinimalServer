# Searles

A minimal server written in Dart

Minimal code that accept commands from both shell and network connections.
Whenever a command is received, it uses 'Isolate' to compute the result so that it doesn't block the execution.

Start it in the terminal window like this:

```bash
dart run
```

## Building executable

To build `.exe` file, run the following command:

```bash
dart compile exe bin/searles.dart
```

## MacOS Service

Choose the location where the server should be run from:

```bash
mkdir /Users/Shared/Searles
cp bin/searles.exe /Users/Shared/Searles/
```

To setup the server as a service under MacOS, move the `.plist` file located in the `service/` directory into the `/Library/LaunchDaemons/` directory.
Edit the path to `.exe` file if you copied it to another location than the one suggested above.

```bash
sudo cp service/com.searles.server.plist /Library/LaunchDaemons/
```

To setup the service:

```bash
sudo launchctl load /Library/LaunchDaemons/com.searles.server.plist
```

And now, don't forget to start the service as it is disabled by default in the `.plist` file

To check the status of the Launchd service:

```bash
sudo launchctl list | grep com.searles.server
```

To start/stop the service:

```bash
sudo launchctl start com.searles.server
sudo launchctl stop com.searles.server
```
