//= require jquery/dist/jquery
//= require bootstrap/tab
//= require lodash
//= require verge/verge.js
//= require keymaster/keymaster
//= require ng-file-upload/angular-file-upload-shim
//= require angular
//= require angular-resource
//= require angular-route
//= require angular-bootstrap
//= require moment
//= require angular-moment
//= require retina.js/dist/retina
//= require ng-file-upload/angular-file-upload
//= require spinjs/spin.js
//= require app
//= require_tree .

key.filter = function (event) {
    var tagName = (event.target || event.srcElement).tagName;
    key.setScope(/^(INPUT|TEXTAREA|SELECT)$/.test(tagName) ? 'input' : 'other');
    return true;
}

