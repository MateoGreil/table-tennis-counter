# lock '3.6.1'

set :application, 'TableTennisCounter'
set :repo_url, 'git@github.com:MateoGreil/table-tennis-counter.git'

set :deploy_to, '/home/ubuntu/apps/TableTennisCounter'

# Les fichiers / dossiers partagés entre les releases
append :linked_files, 'config/database.yml', 'config/secrets.yml'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets'

# La configuration nginx / puma
set :nginx_config_name, 'table_tennis_counter'
set :nginx_server_name, 'pingpong.greil.fr'
set :puma_workers, 2
