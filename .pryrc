# From: https://github.com/pry/pry/wiki/Setting-up-Rails-or-Heroku-to-use-Pry
#
# Load plugins (only those I whitelist)
#Pry.config.should_load_plugins = false
#Pry.plugins["doc"].activate!

# https://github.com/deivid-rodriguez/pry-byebug
if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end

# Hit Enter to repeat last command
Pry::Commands.command /^$/, "repeat last command" do
  _pry_.run_command Pry.history.to_a.last
end
