class ruby-enterprise::base {
    package{'ruby-enterprise':
        ensure => present,
    }
    package{'ruby-enterprise-rubygems':
        ensure => present,
        require => Package['ruby-enterprise'],
    }
}
