# Demo script for quickly spinning up a Linux node 
# which is auto-classified with role "sample_website"

  $role          = 'sample_website'
  $master_ip     = '35.177.92.181'
  $master_url    = 'https://master.inf.puppet.vm:8140/packages/current/install.bash'
  $instance_name = 'aws-demo-host'
  $tags          =  {
    description      => 'awskit Infrastructure',
    department       => 'TSE',
    project          => 'devhops workshops',
    lifetime         => '1d',
    #termination_date => '2018-07-19T11:03:05.626507+00:00',
  }

  $user_data = @("USERDATA"/L)
    #! /bin/bash
    echo "${master_ip} master.inf.puppet.vm master" >> /etc/hosts
    curl -k ${master_url} | bash -s agent:certname=${instance_name} extension_requests:pp_role=${role}
    | USERDATA

  ec2_instance { $instance_name:
    ensure            => running,
    region            => 'eu-west-2',
    availability_zone => 'eu-west-2a',
    subnet            => 'subnet-default-2a',
    image_id          => 'ami-ee6a718a',
    security_groups   => ['awskit-agent'],
    key_name          => 'dimitri.tischenko-eu-west-2',
    instance_type     => 't2.micro',
    user_data         => $user_data,
    tags              => $tags,
  }
