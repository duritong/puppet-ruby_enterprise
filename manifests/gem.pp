# Installs gem for ruby-enterprise
# As a name it expects the name of the gem.
# I you want to want to install a certain version
# you have to append the version to the gem name:
#
#    install a version of mime-types:
#       ruby-enterpise::gem{'mime-types': }
#
#    install version 0.0.4 of ruby-net-ldap:
#       ruby-enterpise::gem{'ruby-net-ldap-0.0.4': }
#
#    uninstall polygot gem (until no such gem is anymore installed):
#       ruby-enterpise::gem{'polygot': ensure => absent }
#
#    uninstall ruby-net-ldap version 0.0.3
#       ruby-enterpise::gem{'ruby-net-ldap-0.0.3': ensure => absent }
#
define ruby-enterpise::gem(
    $ensure = 'present'
){
    include ::ruby-enterprise
    if $name =~ /\-(\d|\.)+$/ {
        $real_name = regsubst($name,'^(.*)-(\d|\.)+$','\1')
        $ree_gem_version = regsubst($name,'^(.*)-(\d+(\d|\.)+)$','\2')
    } else {
        $real_name = $name
    }

    if $ree_gem_version {
        $ree_gem_version_str = "-v ${ree_gem_version}"
        $ree_gem_version_check_str = $ree_gem_version
    } else {
        $ree_gem_version_check_str = '.*'
    }

    if $ensure == 'present' {
        $ree_gem_cmd = 'install'
    } else {
        $ree_gem_cmd = 'uninstall -x'
    }

    exec{"manage_ree_gem_${name}":
        command => "/opt/ruby-enterprise/bin/gem ${ree_gem_cmd} ${real_name} ${ree_gem_version_str}",
        require => Package['ruby-enterprise-rubygems'],
    }

    $ree_gem_cmd_check_str = "/opt/ruby-enterprise/bin/gem list | egrep -q '^${real_name} \\(${ree_gem_version_check_str}\\)\$'"
    if $ensure == 'present' {
        Exec["manage_ree_gem_${name}"]{
           unless => $ree_gem_cmd_check_str
        }
    } else {
        Exec["manage_ree_gem_${name}"]{
           onlyif => $ree_gem_cmd_check_str
        }
    }
}
