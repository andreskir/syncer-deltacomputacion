beforeEach ->
  @addMatchers
    toDeepEqual: (expected) ->
      actualJson = JSON.stringify @actual
      expectedJson = JSON.stringify expected

      notText = if @isNot then " not" else ""
      @message = -> "Expected #{actualJson}#{notText} to deep equal #{expectedJson}"

      actualJson == expectedJson
