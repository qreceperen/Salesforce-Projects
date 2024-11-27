public with sharing class contactTriggerHandler {

    // Helper Method to calculate nextBirthday
    private static Date calculateNextBirthday(Date birthdate){

        if(birthdate == null) return null;
        // Calculate today's date and birthday this year
        Date today = Date.today();
        Date nextBirthday = birthdate.addYears(today.year() - birthdate.year());

        if(nextBirthday < today){
            nextBirthday = nextBirthday.addYears(1);
        }
        return nextBirthday;
    }

    public static void insertContactHandle(List<Contact> contacts){
        for(Contact contact : contacts){
            if(contact.Birthdate != null){
                contact.Next_Birthday__c = calculateNextBirthday(contact.Birthdate);
            }
        }
    }

    public static void updateContactHandle(List<Contact> contacts, Map<id, Contact> oldContacts ){
        for(Contact contact : contacts){
            Date oldBirthdate = oldContacts.get(contact.Id).Birthdate;

            //Check if birthdate has changed
            if(contact.Birthdate != oldBirthdate){
                    contact.Next_Birthday__c = calculateNextBirthday(contact.Birthdate);

            }
        }
    }
}

