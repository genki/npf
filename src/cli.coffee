argv = require 'argv'
colors = require 'colors'
readline = require 'readline'

ENDPOINT = 'https://www.npmjs.com/search'

@run = ->
  # parse options
  {targets,options} = do argv.option([
    name:'version', short: 'v', type:'bool'
  ]).run
  if options.version
    pkg = require "#{__dirname}/../package.json"
    console.log "#{pkg.name}-#{pkg.version}"
    do process.exit
  if targets.length == 0
    console.error "search words are empty"
    process.exit 1

  # prepare for search session
  q = targets.map(encodeURIComponent).join '+'
  http = require 'cheerio-httpcli'
  rl = readline.createInterface
    input:process.stdin, output:process.stdout, terminal:false
  process.on 'SIGINT', ->
    console.log ''
    do process.exit

  # fetch search result interactively
  fetch = (page) ->
    http.fetch ENDPOINT, q:q, page:page, (err, $, res) ->
      $('.package-details').each (i,e) ->
        e = $(e)
        name = do e.find('.name').text
        desc = e.find('.description').text().replace(/[\s\n]+/g, ' ').blue
        star = "*".repeat(Number do e.find('.stars').text).yellow
        ver  = do e.find('.version').text
        console.log "#{name} #{ver}#{star} #{desc}"
      if $('.pagination .next').length > 0
        process.stdout.write '[ENTER] to more...'
        rl.on 'line', -> fetch page+1
      else do process.exit
  fetch(1)
