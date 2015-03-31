'use strict'

app.controller 'HistoryCtrl', ($scope, Auth) ->
  Auth.getCurrentUser().$promise.then (user) ->
    $scope.history = _.sortBy(user.history, "date").reverse()
