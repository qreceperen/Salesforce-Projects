public with sharing class SMSNotification implements Notification {
    public void send(String  recipient, String message) {
        System.debug('Sending SMS to ' + recipient + ' with message ' + message);
    }
}