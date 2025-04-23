const { environment } = require('@rails/webpacker')

module.exports = environment

const webpack = require('webpack')
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

// Add resolve configuration for React and ES modules
environment.config.merge({
  resolve: {
    extensions: ['.js', '.jsx', '.mjs'],
    alias: {
      'react': require.resolve('react'),
      'react-dom': require.resolve('react-dom'),
      'react-dom/server': require.resolve('react-dom/server')
    }
  },
  module: {
    rules: [
      {
        test: /\.mjs$/,
        include: /node_modules/,
        type: 'javascript/auto'
      },
      {
        test: /react_ujs/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-react'],
            plugins: [
              '@babel/plugin-transform-modules-commonjs'
            ]
          }
        }
      }
    ]
  }
})

const nodeModulesLoader = environment.loaders.get('nodeModules');
if (!Array.isArray(nodeModulesLoader.exclude)) {
  nodeModulesLoader.exclude = nodeModulesLoader.exclude == null ? [] : [nodeModulesLoader.exclude];
}

nodeModulesLoader.exclude.push(/react-table/);
