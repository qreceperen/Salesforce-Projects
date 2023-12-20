public class YearCompare implements Comparator<Employee> {
  public Integer compare(Employee e1, Employee e2) {
    // Guard against null operands for ‘<’ or ‘>’ operators because
    // they will always return false and produce inconsistent sorting
    Integer result;
    if (e1?.getYear() == null && e2?.getYear() == null) {
      result = 0;
    } else if (e1?.getYear() == null) {
      result = -1;
    } else if (e2?.getYear() == null) {
      result = 1;
    } else if (e1.getYear() < e2.getYear()) {
      result = -1;
    } else if (e1.getYear() > e2.getYear()) {
      result = 1;
    } else {
      result = 0;
    }
    return result;
  }
}
