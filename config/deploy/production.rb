set :stage, :production

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :app, %w{designcrit.io}
role :web, %w{designcrit.io}
role :db,  %w{designcrit.io}

set :rails_env, fetch(:stage)

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server 'designcrit.io', user: 'amirraminfar', roles: %w{web app}


# fetch(:default_env).merge!(rails_env: :production)
