import Ember from 'ember';
import ApplicationAdapter from './adapters/application';
import RelationshipAdapter from './adapters/relationship';
import RelateableMixin from './mixins/relateable';
import HistoricalMixin from './mixins/historical';
import Paranoia from './mixins/paranoia';
import Timestamps from './mixins/timestamps';
import Realtime from './mixins/realtime';
import RelationshipModel from './models/relationship';
import RelationshipSerializer from './serializers/relationship';
import Payload from './utils/payload';
import SessionStateMixin from './mixins/session-state';
import CookieCredentialsMixin from './mixins/cookie-credentials';
import QueryUtils from './utils/query';
import virtual from './utils/virtual';
import action from './utils/action';
import about from './utils/about';
import Schema from './utils/schema';
import _x from './utils/xdash';
import {RouteData, DSL} from './utils/router-dsl';
const Mixins = {
  Paranoia,
  Timestamps,
  Realtime,
  Relateable: RelateableMixin,
  Historical: HistoricalMixin
};
const VERSION = "0.1.42";
const computed = _x.computed;
if (Ember.libraries) {
  Ember.libraries.register("AutoX", VERSION);
}
export {
  VERSION,
  ApplicationAdapter,
  RelationshipAdapter,
  RouteData,
  DSL,
  Mixins,
  RelateableMixin,
  HistoricalMixin,
  RelationshipModel,
  RelationshipSerializer,
  Payload,
  SessionStateMixin,
  CookieCredentialsMixin,
  QueryUtils,
  Schema,
  about,
  action,
  virtual,
  _x,
  computed
};