name 'load_balancer'
run_list('haproxy::app_lb')
override_attributes(
  'haproxy' => {
    'admin' => {
     'address_bind' => "0.0.0.0" # In prodcution, remove this for security
    },
    'app_server_role' => "app",
    'member_port' => "80"
  },
)
