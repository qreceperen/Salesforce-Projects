Id customerId = '003D500001BKRUYIA5'; // Replace with a real Contact Id

Map<String, Object> stats = TrainingController.getCustomerTrainingStats(customerId);

for (String key : stats.keySet()) {
    System.debug(key + ' => ' + stats.get(key));
}

