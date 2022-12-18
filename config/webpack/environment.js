const { environment } = require('@rails/webpacker')

module.exports = environment


const webpack = require('webpack')
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Popper: 'popper.js'
  })
)


//const { environment } = require('@rails/webpacker')

//const webpack = require('webpack')

//environment.plugins.prepend(
//  'Provide',
//  new webpack.ProvidePlugin({
//    jQuery: 'jquery',
//  })
//)

//module.exports = environment