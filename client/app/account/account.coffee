'use strict'

angular.module 'parsimotionSyncerApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'login',
    url: '/login'
    templateUrl: 'app/account/login/login.html'
    controller: 'LoginCtrl'

  .state 'signup',
    url: '/signup'
    templateUrl: 'app/account/signup/signup.html'
    controller: 'SignupCtrl'

  .state 'settings',
    url: '/settings'
    templateUrl: 'app/account/settings/settings.html'
    controller: 'SettingsCtrl'
    authenticate: true

  .state 'settings.tokens',
    url: '/tokens'
    templateUrl: 'app/account/settings/settings-tokens.html'

  .state 'settings.syncer',
    url: '/syncer'
    templateUrl: 'app/account/settings/settings-syncer.html'

  .state 'settings.colores',
    url: '/colores'
    templateUrl: 'app/account/settings/settings-colores.html'

  .state 'settings.producteca',
    url: '/producteca'
    templateUrl: 'app/account/settings/settings-producteca.html'
