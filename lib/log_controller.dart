import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

/**
 * A Polymer element that controls the global logging behavior of an
 * application.
 */
@CustomTag('log-controller')
class LogController extends PolymerElement {
  // A string representation of the current logging level.
  @published String logLevel = (() => Logger.root.level.name)();

  // Whether or not this should automatically pass all logs through to the
  // console.
  @published bool printToConsole = true;

  // Static listener on the root logger, null if printToConsole == false.
  static StreamSubscription _logListener;
  // Names for all the valid logging levels.
  static List<String> allLevelNames = () {
    return new List<String>.from(Level.LEVELS.map((level) => level.name));
  }();

  LogController.created() : super.created() {
    setListeningState();
  }

  List<String> get levelNames => LogController.allLevelNames;

  // Listens to logLevel changes and updates the root logger accordingly.
  void logLevelChanged(String oldLogLevel, String newLogLevel) {
    // Force the uppercase version of the level names.
    var upperNewLogLevel = newLogLevel.toUpperCase();
    if (newLogLevel != upperNewLogLevel) {
      this.logLevel = upperNewLogLevel;
      return;
    }

    // Set the level using its name, and close the panel.
    setLevelByName(newLogLevel);
    if (this.$['collapseLevels'].opened) {
      this.$['collapseLevels'].toggle();
    }
  }

  // Any time printToConsole changes, make sure _logListener is updated.
  void printToConsoleChanged() => setListeningState();

  void setLevelByName(String name) {
    var level = Level.LEVELS.firstWhere(
        (level) { return level.name == name;},
        orElse: () {
          _logger.warning("log level $name not found");
          return null;
        }
    );
    if (level != null) Logger.root.level = level;
  }

  void toggleCollapseLevels() => $['collapseLevels'].toggle();

  // Starts/Stops listening to the logger and printing to the console, depending
  // on the printToConsole setting.
  void setListeningState() {
    if (_logListener == null && printToConsole) {
      _logListener = Logger.root.onRecord.listen((rec) {
        print(rec.message);
      });
    } else if (_logListener != null && !printToConsole) {
      _logListener.cancel();
      _logListener = null;
    }
  }
}

