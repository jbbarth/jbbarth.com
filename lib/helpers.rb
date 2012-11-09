#some useful nanoc helpers
include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::LinkTo

#ours
require 'json'
module NanocHelpers
  #these helpers are *stupid* and I know that
  #but for now they work, and I couldn't figure out how to do that
  #correctly with nanoc classes...
  def stupid_render(path)
    html = ""
    title = YAML.load_file(path)["title"]
    date = Date.parse path.scan(/\/(\d{4}-\d{2}-\d{2})/).first.first
    %(#{date.strftime("%d %b %Y")} <a href="#{path.gsub(%r{^./content},'')})
    html << File.read(path).split("---\n")[2..-1].join("---\n")
  end

  def stupid_list_links(paths)
    paths.map do |path|
      title = YAML.load_file(path)["title"]
      date = Date.parse path.scan(/\/(\d{4}-\d{2}-\d{2})/).first.first
      %(<span class="time">#{date.strftime("%d %b %Y")}</span> <a href="#{path.gsub(%r{^./content},'')}">#{title}</a>) if title
    end.compact.join('<br>')
  end

  def json_block(&block)
    raise "Gimme a block" unless block_given?
    html = json_pretty(capture(&block).strip)
    html = %(<pre><code data-language="javascript">)+html+%(</code></pre>)
    buffer = eval('_erbout', block.binding)
    buffer << html
  end

  def json_pretty(json_string)
    JSON.pretty_generate(JSON.parse(json_string))
  end

  def buffer
  end
end
include NanocHelpers
