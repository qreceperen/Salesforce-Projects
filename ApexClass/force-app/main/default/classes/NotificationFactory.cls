public with sharing class NotificationFactory {
    public static Notification getNotification(String type){
        if(type == 'Email'){
            return new EmailNotification();
        } else if(type == 'SMS'){
            return new SMSNotification();
        } else {
            throw new IllegalArgumentException ('Invalid notification Type');
        }
    }
}