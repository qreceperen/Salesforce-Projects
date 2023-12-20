public class Employee {
  private Long id;
  private String name;
  private Integer yearJoined;
  // Constructor
  public Employee(Long i, String n, Integer y) {
    id = i;
    name = n;
    yearJoined = y;
  }
  public String getName() {
    return name;
  }
  public Integer getYear() {
    return yearJoined;
  }
}
