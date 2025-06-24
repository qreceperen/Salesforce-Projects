/**
 * BaseTriggerHandler - Abstract base class for all trigger handlers
 * Implements the Template Method pattern
 Purpose of BaseTriggerHandler
    It is an abstract superclass for all your trigger handlers (like PropertyTriggerHandler, UnitTriggerHandler, etc.).
    Its job is to:
    Read the trigger context
    Decide which action to run (beforeInsert, afterUpdate, etc.)
    Provide utility functions like bypass for testing
 */
public abstract class BaseTriggerHandler {
  protected TriggerContext context;
  private Map<String, ITriggerStrategy> strategies;
  private static Set<String> bypassedHandlers = new Set<String>();

  /*
    Gets current trigger info via TriggerContext
    Initializes an empty strategy map
    Calls setStrategies() — this is where you add things like 'beforeInsert' => new PropertyValidationStrategy() from the child class
    */
  public BaseTriggerHandler() {
    this.context = TriggerContext.getInstance();
    this.strategies = new Map<String, ITriggerStrategy>();
    setStrategies();
  }

  // Template method - defines the algorithm structure
  public void execute() {
    System.debug('▶️ BaseTriggerHandler: executing trigger handler');

    if (isBypassed()) {
      System.debug('⏭️ Handler is bypassed');
      return;
    }

    try {
      if (context.isBefore) {
        if (context.isInsert) {
          System.debug('🔁 Strategy = beforeInsert');
          executeStrategy('beforeInsert');
        }
        if (context.isUpdate) {
          System.debug('🔁 Strategy = beforeUpdate');
          executeStrategy('beforeUpdate');
        }
        if (context.isDelete) {
          System.debug('🔁 Strategy = beforeDelete');
          executeStrategy('beforeDelete');
        }
      }

      if (context.isAfter) {
        if (context.isInsert) {
          System.debug('🔁 Strategy = afterInsert');
          executeStrategy('afterInsert');
        }
        if (context.isUpdate) {
          System.debug('🔁 Strategy = afterUpdate');
          executeStrategy('afterUpdate');
        }
        if (context.isDelete) {
          System.debug('🔁 Strategy = afterDelete');
          executeStrategy('afterDelete');
        }
        if (context.isUndelete) {
          System.debug('🔁 Strategy = afterUndelete');
          executeStrategy('afterUndelete');
        }
      }
    } catch (Exception e) {
      handleException(e);
    }

    System.debug(
      '⚡ Phase: ' +
        (context.isBefore ? 'Before' : 'After') +
        ' / Insert=' +
        context.isInsert +
        ' / Update=' +
        context.isUpdate +
        ' / Delete=' +
        context.isDelete
    );
  }

  // Abstract method - subclasses must implement
  protected abstract void setStrategies();

  private void executeStrategy(String operation) {
    System.debug('🔎 Looking for strategy: ' + operation);
    ITriggerStrategy strategy = strategies.get(operation);
    if (strategy != null) {
      System.debug('✅ Found strategy for: ' + operation);
      strategy.execute();
    } else {
      System.debug('❌ No strategy defined for: ' + operation);
    }
  }

  protected void addStrategy(String operation, ITriggerStrategy strategy) {
    strategies.put(operation, strategy);
  }

  // Bypass mechanism for testing and special scenarios
  public static void bypass(String handlerName) {
    bypassedHandlers.add(handlerName);
  }

  public static void clearBypass(String handlerName) {
    bypassedHandlers.remove(handlerName);
  }

  public static void clearAllBypasses() {
    bypassedHandlers.clear();
  }

  private Boolean isBypassed() {
    return bypassedHandlers.contains(getHandlerName());
  }

  protected virtual String getHandlerName() {
    return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
  }

  private void handleException(Exception e) {
    // Log the exception and re-throw
    System.debug(
      LoggingLevel.ERROR,
      'Trigger Exception in ' + getHandlerName() + ': ' + e.getMessage()
    );
    System.debug(LoggingLevel.ERROR, 'Stack Trace: ' + e.getStackTraceString());
    throw e;
  }
}
