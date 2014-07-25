import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

/**
 * A Polymer element that controls the global logging behavior of an
 * application.
 */
@CustomTag('log-controller')
class LogController extends PolymerElement {
  // A string representation of the current logging level.
  // TODO(jakemac): Once available switch to the new property pattern:
  //   @published
  //   String get logLevel => readValue(#logLevel);
  //   set logLevel(String value) => writeValue(#logLevel, value.toUpperCase());
  @published String logLevel = Logger.root.level.name;

  // Whether or not this should automatically pass all logs through to the
  // console.
  @published bool printToConsole = true;

  // Static listener on the root logger, null if printToConsole == false.
  static StreamSubscription _logListener;
  // Names for all the valid logging levels.
  static final Map<String, Level> _ALL_LEVELS = () {
    var map = {};
    Level.LEVELS.forEach((l) { map[l.name] = l; });
    return map;
  }();

  LogController.created() : super.created() {
    updateListenter();
  }

  Iterable<String> get levelNames => LogController._ALL_LEVELS.keys;

  // Listens to logLevel changes and updates the root logger accordingly.
  void logLevelChanged(String oldLogLevel, String newLogLevel) {
    // Set the level using its name, and close the panel.
    setLevelByName(newLogLevel);
    if (this.$['collapseLevels'].opened) {
      this.$['collapseLevels'].toggle();
    }
  }

  // Any time printToConsole changes, make sure _logListener is updated.
  void printToConsoleChanged() => updateListenter();

  void setLevelByName(String name) {
    var level = _ALL_LEVELS[name];
    if (level == null) {
      _logger.warning("log level $name not found");
      return;
    }
    Logger.root.level = level;
  }

  void toggleCollapseLevels() => $['collapseLevels'].toggle();

  // Starts/Stops listening to the logger and printing to the console, depending
  // on the printToConsole setting.
  void updateListenter() {
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

