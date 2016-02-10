import PageObject from 'dummy/tests/page-object';

const {
  visitable,
  clickable,
  fillable
} = PageObject;

const Shop = {
  name: "Test Shop " + Math.random(),
  location: "Los Angeles, CA",
  theme: "Standardized Testing"
};

const Core = {
  visit: visitable('/shops/new'),
  name: fillable("input[name=name]"),
  theme: fillable("input[name=theme]"),
  submit: clickable("button[type=submit]"),
  createShop() {
    return this.name(Shop.name).theme(Shop.theme).submit();
  }
};

export default PageObject.create(Core);
