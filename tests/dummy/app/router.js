import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route("user");
  this.route("chairs", {path: "/chairs"}, function() {
    this.route("new");
    this.route("edit");
    this.route("chair", {path: "/chair/:chair_id"}, function() {});
  });
  this.route("chair", {path: "/chair/:chair_id"}, function() {});
});

export default Router;
