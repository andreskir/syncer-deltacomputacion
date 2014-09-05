app.filter "checkmark", ->
  (input) ->
    switch (input)
      when "ok" then "✔"
      when "error" then "✘"
      else "-"
