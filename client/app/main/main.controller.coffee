'use strict'

angular.module 'parsimotionSyncerApp'
.controller 'MainCtrl', ($scope, $http) ->
  $scope.files = []

  $http.get('/api/files').success (files) ->
    $scope.files = files
