require 'facter'

Facter.add(:esxi_version) do
  confine :virtual => :vmware
  confine :kernel => :Linux
  setcode do
    bios_lookup_table = {
      'E72C0' => '5.0',
      'EA0C0' => '5.1',
      'EA050' => '5.5'
    }
    bios_lookup_table.default = 'unknown:untranslated_version'
    dmi_path = Facter::Util::Resolution.exec('which dmidecode 2> /dev/null')
    if dmi_path.nil?
      'unknown:no_dmidecode'
    else
      bios_output = Facter::Util::Resolution.exec("#{dmi_path} -t bios 2> /dev/null")
      if bios_output.nil?
        'unknown:dmidecode_empty_output'
      else
        bios_address_line = bios_output.match(/Address: 0x(.*)/i)
        if bios_address_line.nil?
          'unknown:dmidecode_parsing_error'
        else
          bios_lookup_table[bios_address_line[1]]
        end
      end
    end
  end
end
