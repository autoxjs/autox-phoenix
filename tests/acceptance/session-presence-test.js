/* jshint expr:true */
import {
  describe,
  it,
  before,
  after
} from 'mocha';
import { expect } from 'chai';
import startApp from '../helpers/start-app';
import destroyApp from '../helpers/destroy-app';
import LoginPage from 'dummy/tests/pages/login';

describe('Acceptance: SessionPresence', function() {
  let application;

  before(function(done) {
    application = startApp();
    visit('/');
    andThen(function() { done(); });
  });

  after(function() {
    destroyApp(application);
  });

  it('can redirect anonymous users', function() {
    expect(currentPath())
    .to.equal("login");

    expect(LoginPage.pageTitle)
    .to.equal("Login Page");
  });

  describe('can properly login', function() {
    let session;
    before(function(done) {
      LoginPage.login();
      session = application.__container__.lookup("service:session");
      andThen(function() { done(); });
    });

    it('should authenticate the session', function() {
      expect(session.get("isAuthenticated"))
      .to.be.ok;
    });

    it("should redirect the user to the dashboard", function() {
      expect(currentPath())
      .to.equal("dashboard.index");
    });
  });
});
