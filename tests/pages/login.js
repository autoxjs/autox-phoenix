import {
  create,
  visitable,
  text
} from 'ember-cli-page-object';

export default create({
  visit: visitable('/login'),
  pageTitle: text("h1.page-title")
});
