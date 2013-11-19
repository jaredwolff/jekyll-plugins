Adapted from [Jekyll plugins](https://github.com/aucor/jekyll-plugins) by Aucor
=======================

Overview
--------

Plugins included in this repository:

* **strip.rb** - Block tag for trimming away unwanted newlines and whitespace between them.

Usage
-----

### strip.rb

Using eg. forloops to generate navigation produces often a huge amount of ugly whitespace. Wrapping the section with `{% strip %}{% endstrip %}` replaces the blocks of whitespace with one newline resulting in pretty markup.

Author
------

Plugins written by Janne Ala-Äijälä of [Aucor Oy](http://www.aucor.fi)
