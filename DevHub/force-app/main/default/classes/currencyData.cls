public class currencyData {
  public class Info {
    public Double quote;
    public Integer timestamp;
  }
  public class Query {
    public Integer amount;
    public String currencyFrom;
    public String to;
  }
  public Info info;
  public Query query;
  public Double result;
  public Boolean success;
}
