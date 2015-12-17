require 'rest-client'

def icon_names(file, regexp)
  response = RestClient.get file
  response.scan(regexp).flatten
end

puts "Scraping Font Awesome..."
fa_icons = icon_names 'https://raw.githubusercontent.com/FortAwesome/Font-Awesome/master/scss/_icons.scss', /^\.\#{\$fa-css-prefix}-(.+):before/
puts "Done. Found #{fa_icons.count} classes\n\n"

puts "Scraping Glyphicons..."
gl_icons = icon_names 'https://raw.githubusercontent.com/twbs/bootstrap-sass/master/assets/stylesheets/bootstrap/_glyphicons.scss', /^\.glyphicon-(\S+)\s*{\s&:before/
puts "Done. Found #{gl_icons.count} classes\n\n"

puts "Scraping Material Design Icons..."
mdi_icons = icon_names 'https://raw.githubusercontent.com/Templarian/MaterialDesign-Webfont/master/css/materialdesignicons.css', /^\.mdi-(.+):before/
puts "Done. Found #{mdi_icons.count} classes\n\n"

puts "Scraping Elusive icons..."
els_icons = icon_names 'https://raw.githubusercontent.com/reduxframework/elusive-icons/master/scss/_icons.scss', /^\.\#{\$el-css-prefix}-(.+):before/
puts "Done. Found #{els_icons.count} classes\n\n"

icons = (fa_icons + gl_icons + mdi_icons + els_icons).uniq.sort

puts "Output table"
for icon in icons
  puts <<-HTML
        <tr><td><a href="##{icon}" id="#{icon}">#{icon}</a></td><td><i class="fa fa-#{icon}"></i></td><td><i class="glyphicon glyphicon-#{icon}"></i></td><td><i class="mdi mdi-#{icon}"></i></td><td><i class="el el-#{icon}"></i></td></tr>
  HTML
end
