#!/usr/bin/ruby


require 'socket'
require 'ovirtsdk4'
require 'erb'

vlanFilePath = "/etc/puppetlabs/code/environments/production/hieradata/virtual/"
ca_path = "/opt/ovirt/ca.pem"

class Erb
  include ERB::Util
  attr_accessor :vlanid, :vmname, :template

  def initialize (vlanid, template)
    @vlanid = vlanid
    #@vmname = vmname
    @template = template
  end

  def render
    ERB.new(@template).result( binding )
  end

  def save(file)
    File.open(file, "w+") do |f|
      f.write(render)
    end
  end
end


def get_template()
  %{
---

vlan:<% @vlanid.each do |vlan| %>
  <%= vlan %><% end %>
  }
end


def getVmVlan()

  getHostname = `hammer -u admin -p <password> fact list --search 'is_virtual' | awk '{print $1}' | grep -v ovirt

  connection = OvirtSDK4::Connection.new({
    :url => 'https://ovirt-engine.<url>/ovirt-engine/api',
    :username => 'admin@internal',
    :password => '<password>',
    :ca_file => ca_path,
   })

  vlandata = ['---']

  getHostname.each_line do | hostname |
    system_service = connection.system_service
    vms_service = system_service.vms_service
    vm = vms_service.list(search: "name=#{hostname}")[0]
    nics = connection.follow_link(vm.nics)
    nic = nics[0]
    network = connection.follow_link(nic.vnic_profile)
    vlan = network.name.split('Vlan').map { |s| s.to_i }

    vlandata << "'#{vm.name}': #{vlan[1]}"
    end
  return vlandata
  connection.close
end

list = Erb.new(getVmVlan, get_template)
list.save(File.join(vlanFilePath, 'kvm_vlan.yaml'))
