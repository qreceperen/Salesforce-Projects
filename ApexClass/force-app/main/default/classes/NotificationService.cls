public with sharing class NotificationService {
    public void sendNotification(String type, String recipient, String message) {
        Notification notification = NotificationFactory.getNotification(type);
        notification.send(recipient, message);
    }
}