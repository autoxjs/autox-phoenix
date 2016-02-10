import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route("user");
  this.route("chairs", {path: "/chairs"}, function() {
    this.route("new");
  });
  this.route("chair", {path: "/chair/:chair_id"}, function() {
    this.route("edit");
  });
  this.route("shops", {path: "/shops"}, function() {
    this.route("new");
    this.route("shop", {path: "/shop/:shop_id"}, function() {
      this.route("edit");
      this.route("histories", {path: "/histories"}, function(){});
    });
  });
  this.route("finite-state-machine");
  this.route("autox-show-for");
});

export default Router;
