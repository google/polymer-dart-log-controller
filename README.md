# log-controller

A small polymer element which lets you control the global logging configuration, and can optionally log all statements to the console.

## Usage

Simply include the element like any other polymer element.

```
<link rel="import" href="packages/log_controller/log_controller.html">
<log-controller></log-controller>
```

## Attributes

There are two configurable attributes:

- logLevel: The minimum level that all log calls must meet in order to actually be logged.
- printToConsole: Defaults to true, whether the element should log messages to the console.
