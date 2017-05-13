var ExtractTextPlugin = require('extract-text-webpack-plugin');
var path = require('path');

module.exports = {
  entry: './assets/stylesheets/app.scss',

  output: {
    path: path.resolve(__dirname, '.tmp/dist/stylesheets'),
    filename: 'bundle.css'
  },

  module: {
    rules: [
      {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract(
          {
            fallback: "style-loader",
            use: ["css-loader", "sass-loader?outputStyle=expanded"]
          }
        )
      }
    ]
  },

  plugins: [
    new ExtractTextPlugin('bundle.css')
  ]
};
