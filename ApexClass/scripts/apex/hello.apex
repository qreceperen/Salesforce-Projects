List<Account> accList = [
  SELECT
    AccountNumber,
    AnnualRevenue,
    BillingCity,
    BillingCountry,
    BillingPostalCode,
    BillingState,
    BillingStreet,
    CleanStatus,
    Fax,
    Industry,
    Name,
    NumberOfEmployees,
    ShippingCity,
    ShippingCountry,
    ShippingPostalCode,
    ShippingState,
    ShippingStreet,
    Sic,
    Type,
    Website,
    (
      SELECT
        CleanStatus,
        Department,
        Email,
        FirstName,
        LastName,
        LeadSource,
        MailingCity,
        MailingCountry,
        MailingPostalCode,
        MailingState,
        MailingStreet,
        Name,
        OtherCity,
        OtherCountry,
        OtherPhone,
        OtherPostalCode,
        OtherState,
        OtherStreet,
        Phone,
        Salutation,
        Title
      FROM Contacts
    )
  FROM Account
];

for (Account acc : accList) {
  system.debug(acc);
}
