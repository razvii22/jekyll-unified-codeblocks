puts ""
puts "Jekyll-unified-codeblocks #{Jekyll::Unified::Codeblocks::VERSION} has been loaded :3"
puts ""
require 'kramdown/converter/html'

module Kramdown
  module Converter
    class Html
      def convert_codeblock(el, indent)
        attr = el.attr.dup
        lang = extract_code_language!(attr)
        hl_opts = {}
        highlighted_code = highlight_code(el.value, el.options[:lang] || lang, :block, hl_opts)
        if highlighted_code
          add_syntax_highlighter_to_class_attr(attr, lang || hl_opts[:default_lang])
          language = lang || "plaintext"
          "#{' ' * indent}<figure#{html_attributes(attr)}><figcaption>#{language}</figcaption>#{highlighted_code}#{' ' * indent}</figure>\n"
        else
          result = escape_html(el.value)
          result.chomp!
          if el.attr['class'].to_s =~ /\bshow-whitespaces\b/
            result.gsub!(/(?:(^[ \t]+)|([ \t]+$)|([ \t]+))/) do |m|
              suffix = ($1 ? '-l' : ($2 ? '-r' : ''))
              m.scan(/./).map do |c|
                case c
                when "\t" then "<span class=\"ws-tab#{suffix}\">\t</span>"
                when " " then "<span class=\"ws-space#{suffix}\">&#8901;</span>"
                end
              end.join
            end
          end
          code_attr = {}
          code_attr['class'] = "language-#{lang}" if lang
          language = lang || "plaintext"
          "#{' ' * indent}<figure class='highlight language-#{language}' data-lang='#{language}'><figcaption>#{language}</figcaption><pre#{html_attributes(attr)}>" \
            "<code#{html_attributes(code_attr)}>#{result}\n</code></pre></figure>\n"
        end
      end
      def add_syntax_highlighter_to_class_attr(attr, lang = nil)
        (attr['class'] = (attr['class'] || '') + @highlighter_class + " highlight").lstrip!
        attr['class'].sub!(/\blanguage-\S+|(^)/) { "language-#{lang}#{$1 ? ' ' : ''}" } if lang
      end
    end
  end
end

module Jekyll
  module Tags
    class HighlightBlock
      def initialize(tag_name, markup, tokens)
        super
        if markup.strip =~ SYNTAX
          @lang = Regexp.last_match(1).downcase
          @highlight_options = parse_options(Regexp.last_match(2))
        else
          @lang = "plaintext"
          @highlight_options = {}
        end
      end
      def add_code_tag(code)
        code_attrs = %(class="language-#{@lang.tr("+", "-")}" data-lang="#{@lang}")
        %(<figure class="highlight language-#{@lang.tr("+", "-")}" data-lang="#{@lang}" ><figcaption>#{@lang}</figcaption><div class="highlight"><pre class="highlight"><code #{code_attrs}>#{code.chomp}</code></pre></div></figure>)
      end
    end
  end
end
