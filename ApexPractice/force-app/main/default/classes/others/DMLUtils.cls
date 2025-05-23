public with sharing class DMLUtils {
  // Properties
  //----Let's create a datatype for the DML Operation selector
  public enum DMLOperation {
    DO_DELETE,
    DO_INSERT,
    DO_UNDELETE,
    DO_UPDATE,
    DO_UPSERT
  }
  //----Let's give the developer two options for error handling; These should be set before running doOperate;
  //--------Set a related Id
  public static String relatedId;
  //--------Set a subsystem identifier
  public static String subsystem;

  // Public Runners
  public static void doOperate(
    DMLOperation operation,
    List<SObject> recordsToOperateOn
  ) {
    // Logic
    try {
      if (operation == DMLOperation.DO_DELETE) {
        delete recordsToOperateOn;
      }
      if (operation == DMLOperation.DO_INSERT) {
        insert recordsToOperateOn;
      }
      if (operation == DMLOperation.DO_UNDELETE) {
        undelete recordsToOperateOn;
      }
      if (operation == DMLOperation.DO_UPDATE) {
        update recordsToOperateOn;
      }
      if (operation == DMLOperation.DO_UPSERT) {
        upsert recordsToOperateOn;
      }
    } catch (Exception e) {
      //----Log to Debug Console
      System.debug(
        LoggingLevel.ERROR,
        '***The following exception occurred: ' +
        e.getMessage() +
        '***'
      );
      //----Create MTB Error Logs
      //--------The two String options are either null or not; regardless we will pass them to the Error Log generator
      ErrorLog.log(subSystem, e, relatedId);
    }
  }
}