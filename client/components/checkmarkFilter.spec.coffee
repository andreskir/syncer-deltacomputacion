describe 'checkmark filter', ->

  beforeEach module 'parsimotionSyncerApp'

  it 'should convert ok to check', inject (checkmarkFilter) ->
    expect(checkmarkFilter "ok").toBe '\u2714'

  it 'should convert error to cross', inject (checkmarkFilter) ->
    expect(checkmarkFilter "error").toBe '\u2718'

  it 'should convert null to hyphen', inject (checkmarkFilter) ->
    expect(checkmarkFilter null).toBe '-'
