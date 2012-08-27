
def template name
  path = File.expand_path(File.join('..', 'templates', name), __FILE__)
  File.read(path)
end

git :init

file 'Gemfile', template('Gemfile'), force: true
file '.gitignore', template('gitignore'), force: true

application <<EOF
config.generators do |g|
      g.orm             :active_record
      g.template_engine :haml
      g.test_framework  :test_unit, :fixture => true
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
    end
EOF

file 'config/routes.rb', <<-ROUTES, force: true
#{app_const_base}::Application.routes.draw do
  root :to => 'landing#show'
end
ROUTES

run 'bundle install'

generate("simple_form:install --bootstrap")
generate("show_for:install")

run 'rm -Rf lib/templates'
run 'rm app/views/layouts/application.html.erb'
run 'rm app/assets/stylesheets/application.css'
run 'rm public/index.html'
run 'rm README.rdoc'
run 'cp config/database.yml config/database.example.yml'

file 'app/assets/javascripts/application.js', template('application.js'), force: true
file 'app/assets/stylesheets/application.css.scss', template('application.css.scss')
file 'app/controllers/application_controller.rb', template('application_controller.rb'), force: true
file 'app/models/ability.rb', template('ability.rb')
file 'app/views/layouts/_nav.html.haml', template('_nav.html.haml')
file 'app/views/layouts/_nav_user.html.haml', template('_nav_user.html.haml')
file 'app/views/layouts/application.html.haml', template('application.html.haml')
file 'app/views/layouts/devise.html.haml', template('devise.html.haml')
file 'config/initializers/show_for.rb', template('show_for.rb'), force: true
file 'config/locales/en.yml', template('en.yml'), force: true
file 'config/locales/cancan.yml', template('cancan.yml')
file 'config/navigation.rb', template('navigation.rb')
file 'test/test_helper.rb', template('test_helper.rb'), force: true

file 'app/helpers/bootstrap_helper.rb', template('bootstrap_helper.rb')
file 'app/helpers/breadcrumb_helper.rb', template('breadcrumb_helper.rb')
file 'app/helpers/title_helper.rb', template('title_helper.rb')
file 'app/helpers/pagination_helper.rb', template('pagination_helper.rb')
file 'app/helpers/application_helper.rb', <<HELPER, force: true
module ApplicationHelper
  def app_name
    #{app_name.titleize.inspect}
  end
end
HELPER

inside 'lib/templates' do
  inside 'haml/scaffold' do
    file '_form.html.haml', template('templates/_form.html.haml')
    file 'edit.html.haml',  template('templates/edit.html.haml')
    file 'index.html.haml', template('templates/index.html.haml')
    file 'new.html.haml',   template('templates/new.html.haml')
    file 'show.html.haml',  template('templates/show.html.haml')
  end
  file 'rails/scaffold_controller/controller.rb', template('templates/controller.rb')
end

generate("devise:install")
generate("devise", 'user')
generate("devise:views")

file 'test/fixtures/users.yml', template('users.yml'), force: true

generate("controller", 'landing show')

rake 'db:migrate'
rake 'db:fixtures:load'

git add: '.'
git commit: "-a -m 'Initial commit'"

