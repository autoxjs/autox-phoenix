import PageObject from 'dummy/tests/page-object';

import Ember from 'ember';
const {isPresent} = Ember;
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
  hasNameField () {
    return isPresent($("input[name=name]"));
  },
  theme: fillable("input[name=theme]"),
  hasThemeField () {
    return isPresent($("input[name=theme]"));
  },
  submit: clickable("button[type=submit]"),
  selectOwner(name) {
    /* global selectChoose */
    selectChoose(".autox-form-for__select-owner", name);
    return this;
  },
  createShop() {
    return this.name(Shop.name).theme(Shop.theme).selectOwner("test").submit();
  },
  formPresent() {
    return this.hasNameField() && this.hasThemeField();
  }
};

export default PageObject.create(Core);
