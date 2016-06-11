import {
  create,
  visitable,
  text,
  fillable,
  clickable
} from 'ember-cli-page-object';

export default create({
  visit: visitable('/login'),
  pageTitle: text("h1.page-title"),
  email: fillable(".input__email"),
  password: fillable(".input__password"),
  submit: clickable("[type=submit]"),
  login() {
    return this.email("test@test.test").password("password123").submit();
  }
});
