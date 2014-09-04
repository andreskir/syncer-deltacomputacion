describe 'checkmark filter', ->

  beforeEach module 'parsimotionSyncerApp'

  it 'should convert true to check', inject (checkmarkFilter) ->
    expect(checkmarkFilter(true)).toBe '\u2713'

  it 'should convert false to cross', inject (checkmarkFilter) ->
    expect(checkmarkFilter(false)).toBe '\u2718'
