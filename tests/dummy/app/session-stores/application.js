import Cookie from 'ember-simple-auth/session-stores/cookie';

export default Cookie.extend({
  cookieExpirationTime: 365 * 24 * 60 * 60
});