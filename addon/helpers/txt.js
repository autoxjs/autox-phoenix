import Ember from 'ember';
import formatters from '../utils/formatters';

export function txt(value, hash) {
  var message,
      dataType = hash.type,
      formatter = hash.formatter;

  if(value) {
    value = value[0];
  }

  if(value !== undefined && !formatter && dataType) {
    formatter = formatters[dataType];
  }

  try {
    if(formatter && value) {
      value = formatter(value, hash);
    }
  }
  catch(error) {
    message = "Invalid Data!";
    Ember.Logger.error(error);
  }

  if(value === undefined || value === null) {
    return new Ember.Handlebars.SafeString('<span class="txt-message"> Not Available! </span>');
  }
  else {
    return Ember.Handlebars.Utils.escapeExpression(value.toString());
  }

}

export default Ember.Helper.helper(txt);