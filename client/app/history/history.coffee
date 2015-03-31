'use strict'

angular.module 'parsimotionSyncerApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'history',
    url: '/history'
    templateUrl: 'app/history/history.html'
    controller: 'HistoryCtrl'
