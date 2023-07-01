# Searles

A minimal server written in Dart

A sample command-line application with an entrypoint in `bin/`, library code in `lib/`, and example unit test in `test/`.

Minimal code that accept commands from both shell and network connections.
Whenever a command is received, it uses 'Isolate' to compute the result so that it doesn't block the execution.

Start it in the terminal window like this:

```bash
dart run
```