/* jshint expr:true */
import {
  describe,
  it,
  beforeEach,
  afterEach
} from 'mocha';
import { expect } from 'chai';
import startApp from '../helpers/start-app';
import destroyApp from '../helpers/destroy-app';
import LoginPage from 'dummy/tests/pages/login';

describe('Acceptance: SessionPresence', function() {
  let application;

  beforeEach(function() {
    application = startApp();
  });

  afterEach(function() {
    destroyApp(application);
  });

  it('can login the user', function() {
    visit('/');

    andThen(function() {
      expect(currentPath())
      .to.equal("login");

      expect(LoginPage.pageTitle)
      .to.equal("Login Page");

      LoginPage.login();
    });

    andThen(function(){
      expect(currentPath())
      .to.equal("dashboard.index");
    });
  });
});
