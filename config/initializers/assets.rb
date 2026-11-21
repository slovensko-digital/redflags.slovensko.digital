# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

# Bootstrap 4 and Font Awesome 4 are written for older Sass. Dart Sass compiles them,
# only with deprecation warnings, so do not print the ones from the gems.
Rails.application.config.sass.quiet_deps = true
Rails.application.config.sass.silence_deprecations = %w[import global-builtin color-functions]
