# Jekyll Unified Codeblocks
A simple monkey-patched gem that unified Jekyll's `{%highlight%}` tag with Kramdown's GFM style code fences.

# Usage
## HTML
JUC generates the following `general` HTML structure for styling.
```html
<figure class="language-<lang> highlighter-rouge highlight">
    <div class="highlight">
        <pre class="highlight"><code> code! </code></pre>
    </div>
</figure>
```
JUC does not modify how code tags are structured, this still differs between `{% highlight %}` and code fences.

## Installation
JUC internally overrides Jekyll and Kramdown methods when loaded, therefore installation is as simple as adding the following to your Jekyll site Gemfile:
`gem 'jekyll-unified-codeblocks', git: "https://github.com/razvii22/jekyll-unified-codeblocks"`
and then run `bundle install`.  
Then you need to add JUC to the `_config.yml` file of your jekyll project:
```yaml
plugins:
 - jekyll-unified-codeblocks
```
If everything installed and loaded correctly, you should see the following message in your terminal the next time you build or serve your jekyll site:  
`Jekyll-unified-codeblocks has been loaded :3`


# Note
JUC also patches Jekyll's `{% highlight %}` block's annoying behaviour of throwing an error if a language is not specified, instead, it will now default to `plaintext` as the language if none is specified.
