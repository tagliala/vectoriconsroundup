require 'rest-client'
require 'ostruct'
require 'byebug'

fonts = [
  OpenStruct.new(
    name: 'Font Awesome',
    url: 'https://raw.githubusercontent.com/FortAwesome/Font-Awesome/master/scss/_icons.scss',
    regexp: /^\.\#{\$fa-css-prefix}-(.+):before/
  ),
  OpenStruct.new(
    name: 'Glyphicons',
    url: 'https://raw.githubusercontent.com/twbs/bootstrap-sass/master/assets/stylesheets/bootstrap/_glyphicons.scss',
    regexp: /^\.glyphicon-(\S+)\s*{\s&:before/
  ),
  OpenStruct.new(
    name: 'Foundation Icon Fonts',
    url: 'https://raw.githubusercontent.com/zurb/foundation-icon-fonts/master/_foundation-icons.scss',
    regexp: /^\.fi-(.+):before/
  ),
  OpenStruct.new(
    name: 'Ionicons',
    url: 'https://raw.githubusercontent.com/driftyco/ionicons/master/scss/_ionicons-icons.scss',
    regexp: /^\.\#{\$ionicons-prefix}(.+):before/
  ),
  OpenStruct.new(
    name: 'Material Design Icons',
    url: 'https://raw.githubusercontent.com/Templarian/MaterialDesign-Webfont/master/scss/_variables.scss',
    regexp: /^    \"([^\"].+)\"\: /
  ),
  OpenStruct.new(
    name: 'Elusive icons',
    url: 'https://raw.githubusercontent.com/reduxframework/elusive-icons/master/scss/_icons.scss',
    regexp: /^\.\#{\$el-css-prefix}-(.+):before/
  ),
]

def glyph_classes_from_font(font)
  response = RestClient.get font.url
  response.scan(font.regexp).flatten
end

def scrape(font)
  puts "Scraping #{font.name}"
  classes = glyph_classes_from_font font
  puts "Done. Found #{classes.count} classes"
  classes
end

icons = []

for font in fonts
  icons += scrape(font)
  puts "\n\n"
end

icons.uniq!.sort!

output = ["        <tbody id=\"glyphs-j\" class=\"glyphs\">\n"]
for icon in icons
  output << <<-HTML
          <tr><td><a href="##{icon}" id="#{icon}">#{icon}</a></td><td><i class="fa fa-#{icon}"></i></td><td><i class="glyphicon glyphicon-#{icon}"></i></td><td><i class="fi-#{icon}"></i></td><td><i class="ion-#{icon}"></i></td><td><i class="mdi mdi-#{icon}"></i></td><td><i class="el el-#{icon}"></i></td></tr>
  HTML
end
output << "        </tbody>"

contents = File.read('index.html')
new_contents = contents.gsub(/^\s+<tbody id="glyphs-j" class="glyphs">.*<\/tbody>/m, output.join)
File.open('index.html', 'w') { |file| file.puts new_contents }
