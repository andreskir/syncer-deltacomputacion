'use strict'

describe 'Controller: MainCtrl', ->

  # load the controller's module
  beforeEach module 'parsimotionSyncerApp'

  MainCtrl = undefined
  scope = undefined
  $httpBackend = undefined

  # Initialize the controller and a mock scope
  beforeEach inject (_$httpBackend_, $controller, $rootScope) ->
    $httpBackend = _$httpBackend_
    $httpBackend.expectGET('/api/files').respond [
      'mercado.xls'
    ]
    scope = $rootScope.$new()
    MainCtrl = $controller 'MainCtrl',
      $scope: scope

  it 'should attach a list of files to the scope', ->
    $httpBackend.flush()
    expect(scope.files.length).toBe 1
