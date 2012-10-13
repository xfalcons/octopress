# encoding: utf-8
module Jekyll

  class Site

    def create_category_list
      write_to_tag_cloud if @config['category_tag_cloud']
      write_to_sidebar if @config['category_sidebar']
    end

    private
    # generate category tag list and write to 'source/_includes/asides/categories_tag.html'
    def write_to_tag_cloud
      puts ' => Creating Categories Tag Cloud'
      lists = {}
      max, min = 1, 1
      @categories.keys.sort_by{ |str| str.downcase }.each do |category|
        count = @categories[category].count
        lists[category] = count
        max = count if count > max
      end

      html = ''
      lists.each do | category, counter |
        url = get_category_url category
        style = "font-size: #{100 + (50 * Float(counter)/max)}%"
        if @config['category_counter']
          html << " <a href='#{url}' style='#{style}'>#{category.capitalize}(#{@categories[category].count})</a> "
        else
          html << " <a href='#{url}' style='#{style}'>#{category.capitalize}</a> "
        end
      end

      # testing data, should be removed
      # html << '<a href="/category/actionscript" style="font-size: 138.9189189189189%">ActionScript(24)</a>  <a href="/category/asp" style="font-size: 103.24324324324324%">ASP(2)</a>  <a href="/category/aws" style="font-size: 101.62162162162163%">AWS(1)</a>  <a href="/category/book" style="font-size: 101.62162162162163%">Book(1)</a>  <a href="/category/browser" style="font-size: 103.24324324324324%">Browser(2)</a>  <a href="/category/cocos2d" style="font-size: 101.62162162162163%">Cocos2D(1)</a>  <a href="/category/coffeescript" style="font-size: 125.94594594594595%">CoffeeScript(16)</a>  <a href="/category/css" style="font-size: 101.62162162162163%">CSS(1)</a>  <a href="/category/diary" style="font-size: 142.16216216216216%">Diary(26)</a>  <a href="/category/django" style="font-size: 122.70270270270271%">Django(14)</a>  <a href="/category/dojo" style="font-size: 101.62162162162163%">Dojo(1)</a>  <a href="/category/easeljs" style="font-size: 104.86486486486487%">EaselJS(3)</a>  <a href="/category/flash" style="font-size: 160.0%">Flash(37)</a>  <a href="/category/funny" style="font-size: 106.48648648648648%">Funny(4)</a>  <a href="/category/happy-ruby" style="font-size: 103.24324324324324%">Happy Ruby(2)</a>  <a href="/category/html5" style="font-size: 104.86486486486487%">HTML5(3)</a>  <a href="/category/ios-app-development" style="font-size: 114.5945945945946%">iOS App Development(9)</a>  <a href="/category/javascript" style="font-size: 140.54054054054055%">JavaScript(25)</a>  <a href="/category/jquery" style="font-size: 101.62162162162163%">jQuery(1)</a>'

      File.open(File.join(@source, '_includes/asides/categories_tag.html'), 'w') do |file|
        file << """{% if site.category_tag_cloud %}
<section class='well'>
<h1>#{@config['category_title'] || 'Categories'}</h1>
<span class='categories_tag'>#{html}</span>
</section>
{% endif %}
"""
      end
    end

    # generate category lists and write to 'source/_includes/asides/categories_sidebar.html'
    def write_to_sidebar
      puts ' => Creating Categories Sidebar'
      html = "<ul>\n"
      # case insensitive sorting
      @categories.keys.sort_by{ |str| str.downcase }.each do |category|
        url = get_category_url category
        if @config['category_counter']
          html << "  <li><a href='#{url}'>#{category.capitalize} (#{@categories[category].count})</a></li>\n"
        else
          html << "  <li><a href='#{url}'>#{category.capitalize}</a></li>\n"
        end
      end
      html << "</ul>"
      File.open(File.join(@source, '_includes/asides/categories_sidebar.html'), 'w') do |file|
        file << """{% if site.category_sidebar %}
<section>
<h1>#{@config['category_title'] || 'Categories'}</h1>
#{html}
</section>
{% endif %}
"""
      end
    end

    def get_category_url(category)
      dir = @config['category_dir'] || 'categories'
      File.join @config['root'], dir, category.gsub(/_|\P{Word}/, '-').gsub(/-{2,}/, '-').downcase
    end
  end

  class CategoryList < Generator
    safe true
    priority :low

    def generate(site)
      if site.config['category_list']
        puts "## Generating Categories.."
        site.create_category_list
      end
    end
  end

end
