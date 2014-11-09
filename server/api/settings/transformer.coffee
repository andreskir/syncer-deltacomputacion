_ = require("lodash")
_.mixin require("lodash-deep")

class Transformer
  toDto: (model) ->
    parser:
      name: _.deepGet model, "syncer.settings.parser"
    fileName:  _.deepGet model, "syncer.settings.fileName"
    parsimotionToken: _.deepGet model, "tokens.parsimotion"
    priceList: _.deepGet model, "settings.priceList"
    warehouse: _.deepGet model, "settings.warehouse"

  toModel: (dto) -> {}

module.exports = new Transformer()
