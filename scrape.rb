require 'rest-client'

def icon_names(file, regexp)
  response = RestClient.get file
  response.scan(regexp).flatten
end

fa_icons = icon_names 'https://raw.githubusercontent.com/FortAwesome/Font-Awesome/master/scss/_icons.scss', /\#{\$fa-css-prefix}-(.+):before/
gl_icons = icon_names 'https://raw.githubusercontent.com/twbs/bootstrap-sass/master/assets/stylesheets/bootstrap/_glyphicons.scss', /\.glyphicon-(\S+)\s*{\s&:before/
els_icons = icon_names 'https://raw.githubusercontent.com/reduxframework/elusive-icons/master/scss/_icons.scss', /\#{\$el-css-prefix}-(.+):before/

icons = (fa_icons + gl_icons + els_icons).uniq.sort

for icon in icons
  puts <<-HTML
        <tr><td><a href="##{icon}" id="#{icon}">#{icon}</a></td><td><i class="fa fa-#{icon}"></i></td><td><i class="glyphicon glyphicon-#{icon}"></i></td><td><i class="el el-#{icon}"></i></td></tr>
  HTML
end
