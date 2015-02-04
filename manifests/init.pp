# = Class: vmware::tools
#
# Adds the proper OSP repository to a VMware VM. This is then used to install
# VMware tools.
#
# == Requires:
#
# Puppet 2.7 or greater (due to: class_inherits_from_params_class)
#
# == Sample Usage:
#
# class { 'vmware::tools': }
#
# == Resources:
#
# https://www.vmware.com/support/packages
# http://packages.vmware.com/tools/esx/index.html
# http://packages.vmware.com/tools/docs/manuals/osp-esxi-51-install-guide.pdf
#

class vmwaretools_osp (
    $repo_url             = $vmwaretools_osp::params::repo_url,
    $osp_package          = $vmwaretools_osp::params::osp_package,
    $conflicting_packages = $vmwaretools_osp::params::conflicting_packages,
    $service_name         = $vmwaretools_osp::params::service_name,
    $service_enable       = $vmwaretools_osp::params::service_enable,
    $service_provider     = $vmwaretools_osp::params::service_provider,
    $service_start        = $vmwaretools_osp::params::service_start,
    $service_stop         = $vmwaretools_osp::params::service_stop,
    $service_status       = $vmwaretools_osp::params::service_status
) inherits vmwaretools_osp::params {

    yumrepo { 'vmware-osp':
        baseurl  => $repo_url,
        descr    => 'VMware OSP repository',
        enabled  => 1,
        gpgcheck => 0,
    }

    package { $conflicting_packages:
        ensure => absent,
        before => Package[$osp_package]
    }

    package { $osp_package:
        ensure  => latest,
        require => Yumrepo['vmware-osp'],
        before  => Service[$service_name]
    }

    service { $service_name:
        ensure   => running,
        enable   => $service_enable,
        provider => $service_provider,
        start    => $service_start,
        stop     => $service_stop,
        status   => $service_status,
    }
}
