require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe 'bacula::storage::device' do

  let(:title) { 'bacula::storage::device' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    {
      :ipaddress       => '10.42.42.42',
      :operatingsystem => 'Debian',
      :service_autorestart => true,
      :bacula_storage_service => 'Service[bacula-sd]',
      :storage_configs_dir => '/etc/bacula/storage.d',
    }
  end

  describe 'Test device.conf is created with no options' do
    let(:params) do
      {
        :name => 'sample1',
        :archive_device => '/backups/bacula_storage',
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Device {
  Name = "sample1"
  DeviceType = File
  ArchiveDevice = /backups/bacula_storage
  LabelMedia = yes
  RandomAccess = yes
  AutomaticMount = yes
  RemovableMedia = no
  AlwaysOpen = false
}
'
    end
    it { should contain_file('device-sample1.conf').with_path('/etc/bacula/storage.d/device-sample1.conf').with_content(expected) }
  end

  describe 'Test device.conf is created with all main options' do
    let(:params) do
      {
        :name => 'sample2',
        :media_type => 'File01',
        :archive_device => '/backups/bacula_storage',
        :label_media => 'yes',
        :random_access => 'yes',
        :automatic_mount => 'yes',
        :removable_media => 'no' ,
        :always_open => false,
      }
    end
    let(:expected) do
'# This file is managed by Puppet. DO NOT EDIT.

Device {
  Name = "sample2"
  DeviceType = File
  MediaType = File01
  ArchiveDevice = /backups/bacula_storage
  LabelMedia = yes
  RandomAccess = yes
  AutomaticMount = yes
  RemovableMedia = no
  AlwaysOpen = false
}
'
    end
    it { should contain_file('device-sample2.conf').with_path('/etc/bacula/storage.d/device-sample2.conf').with_content(expected) }

    it 'should automatically restart the service, by default' do
      should contain_file('device-sample2.conf').with_notify('Service[bacula-sd]')
    end
  end

end
