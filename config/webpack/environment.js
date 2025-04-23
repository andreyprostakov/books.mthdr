const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

// Add rule for .mjs files
environment.loaders.append('mjs', {
  test: /\.mjs$/,
  include: /node_modules/,
  type: 'javascript/auto'
})

// Add resolve configuration
environment.config.merge({
  resolve: {
    extensions: ['.mjs', '.js', '.jsx', '.json']
  }
})

module.exports = environment

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

const nodeModulesLoader = environment.loaders.get('nodeModules');
if (!Array.isArray(nodeModulesLoader.exclude)) {
  nodeModulesLoader.exclude = nodeModulesLoader.exclude == null ? [] : [nodeModulesLoader.exclude];
}

nodeModulesLoader.exclude.push(/react-table/);
