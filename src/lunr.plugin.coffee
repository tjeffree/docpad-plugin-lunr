lunrdoc = require('./lunrdoc')

# Export Plugin
module.exports = (BasePlugin) ->
  # Define Plugin
  class LunrPlugin extends BasePlugin
    # Plugin name
    name: 'lunr'
    # Provide some helper functions
    extendTemplateData: ({templateData}) ->
      lunrdoc.init(@docpad)
      # helper functions for printing input boxes
      templateData.getLunrSearchPage = (index, placeholder) -> 
        return lunrdoc.getLunrSearchPage(index, placeholder)
      templateData.getLunrSearchBlock = (searchPage, placeholder, submit) ->
        return lunrdoc.getLunrSearchBlock(searchPage, placeholder, submit)

    # hook into the writeAfter event for generating the index/files
    writeAfter: ->
      if (@config.indexes)
        for indexName, index of @config.indexes
          if typeof index.collection == 'String'
            index.collection = [index.collection]
          
          for collection, colIndex of index.collection
            indexCollection = @docpad.getCollection(colIndex)
            if indexCollection
              indexCollection.forEach (document) ->
                lunrdoc.index(indexName, document)
        lunrdoc.save()