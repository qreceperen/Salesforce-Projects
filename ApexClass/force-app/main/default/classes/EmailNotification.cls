public with sharing class EmailNotification implements Notification {
    public void send(String recipient, String message) {
        System.debug('Sending Email To ' + recipient + ' with message ' + message);
    }
}