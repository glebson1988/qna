# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server "178.62.56.233", user: "deployer", roles: %w{app db web}, primary: true
set :rails_env, :production

# sidekiq
set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult the Net::SSH documentation.
# http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start
#
# Global options
# --------------
 set :ssh_options, {
  keys: %w(/home/fun/.ssh/id_rsa /Users/glebgrisakov/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: 2222
 }
