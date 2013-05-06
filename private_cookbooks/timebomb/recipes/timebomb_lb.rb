include_recipe 'haproxy'

tt = resources('template[/etc/haproxy/haproxy.cfg]')
tt.source 'haproxy.cfg'
tt.cookbook 'timebomb'
