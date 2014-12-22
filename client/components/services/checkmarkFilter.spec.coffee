describe 'checkmark filter', ->
  filter = null

  beforeEach ->
    inject (checkmarkFilter) ->
      filter = checkmarkFilter

  it 'should convert ok to check', ->
    expect(filter "ok").toBe '\u2714'

  it 'should convert error to cross', ->
    expect(filter "error").toBe '\u2718'

  it 'should convert null to hyphen', ->
    expect(filter null).toBe '-'
