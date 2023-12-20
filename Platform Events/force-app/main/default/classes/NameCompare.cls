public with sharing class NameCompare implements Comparator<Employee> {
  public Integer compare(Employee e1, Employee e2) {
    if (e1?.getName() == null && e2?.getName() == null) {
      return 0;
    } else if (e1?.getName() == null) {
      return -1;
    } else if (e2?.getName() == null) {
      return 1;
    }
    return e1.getName().compareTo(e2.getName());
  }
}
