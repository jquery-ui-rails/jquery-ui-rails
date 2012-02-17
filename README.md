# jquery-ui-rails

This gem packages the jQuery UI assets (JavaScripts, stylesheets, and images)
for the Rails 3.1+ [asset
pipeline](http://guides.rubyonrails.org/asset_pipeline.html), so you never have
to download a custom package through the [web
interface](http://jqueryui.com/download) again.

## Usage

In your Gemfile, add:

    group :assets do
      gem 'jquery-ui-rails'
    end

## Require Everything

To require all jQuery UI modules, add the following to your application.js:

```javascript
//= require jquery.ui.all
```

Also add the jQuery UI CSS to your application.css:

```css
/*
 *= require jquery.ui.all
 */
```

All images required by jQuery UI are automatically served through the asset
pipeline, so you are good to go! For example, this code will add a
[datepicker](http://jqueryui.com/demos/datepicker/):

```javascript
$(function() {
  $('.datepicker').datepicker();
});
```

## Require Specific Modules

The jQuery UI code weighs 51KB (minified + gzipped) and takes a while to
execute, so for production apps it's recommended to only include the modules
that your application actually uses. Dependencies between JavaScript modules
and between CSS modules are automatically resolved for you. Simply pick one or
more modules from the asset list below.

For example, if you only need the datepicker module, add this to your
application.js:

```javascript
//= require jquery.ui.datepicker
```

In your application.css, require the corresponding CSS module:

```css
/*
 *= require jquery.ui.datepicker
 */
```

## JavaScript Assets

Pick and choose from the following modules:

### UI Core

```javascript
//= require jquery.ui.core
//= require jquery.ui.widget
//= require jquery.ui.mouse
//= require jquery.ui.position
```

You usually do not need to require these directly, as they are pulled in by the
other JavaScript modules as needed.

### Interactions

```javascript
//= require jquery.ui.draggable
//= require jquery.ui.droppable
//= require jquery.ui.resizable
//= require jquery.ui.selectable
//= require jquery.ui.sortable
```

For `jquery.ui.resizable` and `jquery.ui.selectable`, remember to `require`
their matching CSS files in your application.css as well.

### Widgets

```javascript
//= require jquery.ui.accordion
//= require jquery.ui.autocomplete
//= require jquery.ui.button
//= require jquery.ui.dialog
//= require jquery.ui.slider
//= require jquery.ui.tabs
//= require jquery.ui.datepicker
//= require jquery.ui.progressbar
```

For all of these, remember to `require` their matching CSS files in your
application.css as well.

Datepicker has optional i18n modules for non-US locales, named
`jquery.ui.datepicker-xx[-YY]`
([list](https://github.com/jquery/jquery-ui/tree/1.8.16/ui/i18n)), for example:

```javascript
//= require jquery.ui.datepicker-pt-BR
```

### Effects

```javascript
//= require jquery.effects.core
//= require jquery.effects.blind
//= require jquery.effects.bounce
//= require jquery.effects.clip
//= require jquery.effects.drop
//= require jquery.effects.explode
//= require jquery.effects.fade
//= require jquery.effects.fold
//= require jquery.effects.highlight
//= require jquery.effects.pulsate
//= require jquery.effects.scale
//= require jquery.effects.shake
//= require jquery.effects.slide
//= require jquery.effects.transfer
```

## Stylesheet Assets

### UI Core

```css
/*
 *= require jquery.ui.core
 *= require jquery.ui.theme
 */
```

You might want to require these if you do not use any of the following modules,
but still want jQuery UI's basic theming CSS. Otherwise they are automatically
pulled in as dependencies.

### Interactions

```css
/*
 *= require jquery.ui.resizable
 *= require jquery.ui.selectable
 */
```

### Widgets

```css
/*
 *= require jquery.ui.accordion
 *= require jquery.ui.autocomplete
 *= require jquery.ui.button
 *= require jquery.ui.dialog
 *= require jquery.ui.slider
 *= require jquery.ui.tabs
 *= require jquery.ui.datepicker
 *= require jquery.ui.progressbar
 */
```

## Hacking and Contributing

### Setup and Rebuilding the Asset Files

```bash
git clone git://github.com/joliss/jquery-ui-rails.git
cd jquery-ui-rails
git submodule update --init
bundle install
bundle exec rake
```

Pull requests are more than welcome!

### Hacking jQuery UI

You can easily hack jQuery UI through this gem.

```bash
cd jquery-ui
git checkout master # or 1-8-stable
... hack-hack-hack ...
cd ..
bundle exec rake # rebuild assets based on your changes
```

Assuming your app's Gemfile points at your jquery-ui-rails checkout (`gem
'jquery-ui-rails', :path => '~/path/to/jquery-ui-rails'`), all you need to do
now is refresh your browser, and your changes to jQuery UI are live in your
Rails application.

The [jquery-ui](https://github.com/jquery/jquery-ui) project accepts pull
request as well. See also their
[http://wiki.jqueryui.com/w/page/35263114/Getting-Involved](Getting Involved)
guide.

### Testing

As a smoke test, a `testapp` application is available in the repository, which
displays a check mark and a datepicker to make sure the assets load correctly:

```bash
cd testapp
bundle install
rails server
```

Now point your browser at [http://localhost:3000/](http://localhost:3000/).

## License

jQuery UI is dual-licensed under the MIT License (jquery-ui/MIT-LICENSE.txt)
and the GPL version 2 (jquery-ui/GPL-LICENSE.txt). This gem is dual-licensed
under the MIT License (MIT-LICENSE.txt) and the GPL version 2 (GPL-LICENSE.txt)
as well.
