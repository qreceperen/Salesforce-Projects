List<id> productIds = new List<id>();
List<Product2> all = [SELECT Id FROM Product2];
for (Product2 i : all) {
  productIds.add(i.id);
}
ProductBundleManager.createBundle(
  'Rcp Gaming Bundle 2',
  'TEST Description',
  productIds
);

// system.debug(productIds);

