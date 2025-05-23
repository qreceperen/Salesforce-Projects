public class CDDCHandler {

    // Inner class to define the structure of the input parameters
    public class Request {
        @InvocableVariable(required=true)
        public String selectedValues;
    }
    
    // Inner class to define the structure of the output parameters
    public class Response {
        @InvocableVariable
        public String jsonString;
        
        public Response(String jsonString) {
            this.jsonString = jsonString;
        }
    }

    // Invocable method to handle the input from the flow and return JSON string
    @InvocableMethod(label='Handle Selected Values' description='Parses and converts selected values to JSON')
    public static List<Response> handleSelectedValues(List<Request> requests) {
        List<Response> responses = new List<Response>();
        
        // List of all possible options
        List<String> allOptions = new List<String>{
            'Due Diligence Received', 
            'KYC is confirmed', 
            'Appraisal complete', 
            'Environmental Report complete or not required', 
            'Evidence of insurance sufficient', 
            'Flood complete or not required', 
            'Complete'
        };

        // Get current time
        String currentTime = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        
        // Get current user
        String currentUserId = UserInfo.getUserId();
        User currentUser = [SELECT Name FROM User WHERE Id = :currentUserId LIMIT 1];

        // Loop through each request object in the list
        for(Request req : requests) {
            // Split the input string by semicolon to get individual selected items
            List<String> selectedItems = req.selectedValues.split(';');
            
            // Map to hold the JSON structure
            Map<String, Object> jsonMap = new Map<String, Object>();
            
            // Populate the JSON map with all options
            for(String option : allOptions) {
                jsonMap.put(option, selectedItems.contains(option));
            }
            
            // Add lastUpdated and lastUpdatedBy fields to the JSON map
            jsonMap.put('lastUpdated', currentTime);
            jsonMap.put('lastUpdatedBy', currentUser.Name);
            
            // Convert the map to a JSON string
            String jsonString = JSON.serialize(jsonMap);
            
            // Add the JSON string to the response list
            responses.add(new Response(jsonString));
        }
        
        // Return the list of responses
        return responses;
    }
}
